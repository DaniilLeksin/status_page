#!/usr/bin/env ruby

require 'thor'
require_relative 'responseHandler'
require_relative 'inputOutputHandler'
require_relative 'modes'


class StatusPage < Thor
  desc "pull [PATH]", "Request Services and save response into file."
  long_desc <<-LONGDESC
    \x5`status_page pull` will request services from the list and save result to file.
    You can optionally specify parameter [PATH], which will set the file to save results.
    If [PATH] is NOT specified, the `status_page` script will automatically creates the
    output folder (the path to output folder is defined in configuration file) and store
    response data into it. The script uses Unix Time Timestamp as a name of the files.
    \n\n
  LONGDESC
  method_option :path, type: :string,
                       default: nil,
                       desc: "Save result in the specified file."
  def pull
  	mode = Modes.new
  	mode.pull(options[:path])
  end

  desc "live [TIMEOUT][PATH]", "Non Stop periodically Request Services"
  long_desc <<-LONGDESC
    \x5`status_page live` will periodically requests services from the list and save results
    into the files (every request generates separate file with response). You can optionally
    specify parameter [TIMEOUT], which will set timeout before the requests. By DEFAULT [TIMEOUT]
    parameter is set to 1 second. Parameter [PATH] specifies the file to save responses.
    If [PATH] is specified all response data will be saved into this file. If this parameter
    is NOT specified, the script automatically saves results into the file in output folder
    (the path to output folder is defined in configuration file). !!!===To STOP the process please use
    `Ctrl+c`==!!! It will safely mange last response and exit.
    \n\n
  LONGDESC
  method_option :timeout, type: :numeric,
                       default: 1,
                       desc: "Set timeout between the requests (in seconds)."
  method_option :path, type: :string,
                       default: nil,
                       desc: "Save result in the specified file."
  def live
  	mode = Modes.new
  	mode.live(options[:timeout], options[:path])
  end

  desc 'history [PATH] [VERBOSE]', 'Display all data'
  long_desc <<-LONGDESC
    \x5`status_page history` will merge all response data collected in output_folder (path to
    output folder is defined in configuration file) into one history file (path to history folder
    is defined in configuration file). If [PATH] parameter is specified merged data will be
    stored in this file. Parameter [VERBOSE] defines the output merged data into user
    terminal. It accepts to values: `--verbose`/`--no-verbose`. If set `--verbose` key, history files
    will be shown in terminal and vice versa, if `--no-verbose` key is set, display output is disabled.
    By DEFAULT [VERBOSE] is set to `--verbose`. All data will be displayed. All collected response files
    will be moved into the trash_folder (the path to trash folder is defined in configuration file).
    \n\n
  LONGDESC
  method_option :path, type: :string,
                       default: nil,
                       desc: "Save result in the specified file."
  method_option :verbose, type: :boolean,
                       default: true,
                       desc: "Set verbose mode."  
  def history
  	mode = Modes.new
  	mode.history(options[:path], options[:verbose])
  end

  desc 'backup <path>', '[STUB:IN_PROGRESS]Merge History into one file'
  def backup
  	p '[STUB:IN_PROGRESS]Merge History into one file'
  end
  
  desc 'restore <path>', '[STUB:IN_PROGRESS]Restore backup file'
  def restore
  	p '[STUB:IN_PROGRESS]Restore backup file'
  end
end

StatusPage.start(ARGV)
