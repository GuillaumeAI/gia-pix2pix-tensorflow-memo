#!/usr/bin/env node
/** Guillaume Isabelle GIS-CSM
 * Vision: Simply create a contact sheet using Docker container
 
 * Current Reality:First testing
 */
console.log(`

________.___   _____    .______________.___ 
/  _____/|   | /  _  \   |   \__    ___/|   |
/   \  ___|   |/  /_\  \  |   | |    |   |   |
\    \_\  \   /    |    \ |   | |    |   |   |
\______  /___\____|__  / |___| |____|   |___|
	   \/            \/                      
by Guillaume Descoteaux-Isabelle, 2020
	   `);

var container_tag = "jgwill/gia-iti";
if (process.env.gia_tii_container_tag) container_tag = process.env.gia_tii_container_tag;

var mount_in = "/model/input";
var mount_out = "/out";
if (!process.env.model_dir_iti) {
	console.log("You must setup the env, see README.md");
	process.exit(1);
}
var checkpoint_dir = process.env.model_dir_iti;//@STCGoal TODO Get from ENV $

/* @STCAction Add to Readme for .bashrc :
export model_dir=/c/model/models
#ITI
export model_dir_iti=$model_dir/model_gia-ds-tii-2102011823-enginepart-v01-XTrain2102011823-64ik
*/

var checkpoint_mount_path = "/checkpoint";



var path = require('path');
const fs = require('fs')
var resolve = path.resolve;

var os = process.platform;

var myArgs = process.argv.slice(2);
var source_file = myArgs[0];
var source_file_name_only = path.basename(source_file);
var source_dir = path.dirname(source_file);

//@TODO Add conditional output to $input_file__TII_dttime.jpg if NO SECOND ARGS
var target_file = myArgs[1];
var target_dir = path.dirname(target_file);
var target_file_name_only = path.basename(target_file);

// console.log(target_dir);

fs.access(source_file, fs.F_OK, (err) => {
	if (err) {
	  console.error(err);	
	  console.log(`
	  ------------ERROR--- valid  file must be specified as input
	  gia-iti myinput.jpg path/out.jpg
	  ---------------------------------`);
	  
	  process.exit(1);
	  return
	}

		if (os == "win32") {
			//running context will use Powershell to run docker
			const Shell = require('node-powershell');

			const ps = new Shell({
				executionPolicy: 'Bypass',
				noProfile: true
			});

			// ps.addCommand(`$in = \${PWD}.path;$out = Resolve-Path ${target_dir};echo "$in";"$out"`);
			ps.addCommand(`$in = Resolve-Path ${source_dir};$out = Resolve-Path ${target_dir};echo "$in";"$out"`);

			ps.invoke()
				.then(output => {
					//console.log(output);

					make_docker_cmd(output);
				})
				.catch(err => {
					console.log(err);
				});
		}
		else {
			//we assume linux
			var cmd = require('node-cmd');

			//*nix supports multiline commands

			// cwd = cmd.runSync('echo "$(pwd)"');
			// outputting(cwd);
			cmd.run(
				`export indir="$(cd "$(dirname "${source_dir}")"; pwd -P)";export outdir="$(realpath ${target_dir})";echo "$indir\n$outdir"`,
				function (err, data, stderr) {
					// console.log(data);
					make_docker_cmd(data);
				}
			);

		}

	}
	
);


function make_docker_cmd(output) {
	var arr = output.split("\n");
	var inPath = arr[0];
	var outPath = arr[1];
	/*
	
		`-e "SET_CONTAINER_TIMEZONE=true" ` +
		`-e "CONTAINER_TIMEZONE=America/Toronto" ` +
		`-v /etc/timezone:/etc/timezone:ro ` + 
	*/
	var cmdToRun =
		`docker run -d -t --rm ` +
		`-v ${inPath.trim()}:${mount_in} ` +
		`-v ${outPath.trim()}:${mount_out}  ` +
		`-v ${checkpoint_dir.trim()}:${checkpoint_mount_path}  ` +
		`${container_tag}  ` +
		`${source_file_name_only}` +
		` ` +
		`${target_file_name_only}`;
	console.log(`Running : ${cmdToRun}`);
	platform_run(cmdToRun);

}







function platform_run(cmdToRun) {

	console.log("Running: " + cmdToRun);
	console.log("  on platform: " + os);

	if (os == "win32") {
		//running context will use Powershell to run docker
		const Shell = require('node-powershell');

		const ps = new Shell({
			executionPolicy: 'Bypass',
			noProfile: true
		});

		ps.addCommand(cmdToRun);
		ps.invoke()
			.then(output => {
				console.log(output);
				console.log("--Win32 Issue:  You can press CTRL+C to break back to terminal at any time");
			})
			.catch(err => {
				console.log(err);
			});
	}
	else {
		//we assume linux
		var cmd = require('node-cmd');

		cmd.run(
			cmdToRun,
			function (err, data, stderr) {
				console.log(data);

			}
		);

	}

	console.log(`---------------------------
		Container is working in background and will stop when done :)`);
	console.log(` your result will be : ${target_file}
		---------------------------------------`);
}