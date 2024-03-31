require 'find'
require 'awesome_print'
require 'pry'


class Watch
  FOLDER_PATH = '/Users/markdonahue/Desktop/audios/'
  WHISPER_MODEL = 'medium.en'
  def run
    while true
      @files = get_files
      if @files.count < 2
        puts "no files found! sleeping"
        sleep 15
        next
      end

      transcribe
      collate
    end
  end

  def collate
    # Specify the name of the big file to be created
    big_file_name = 'collated_output.txt'

    # Combine folder path and big file name
    big_file_path = File.join(FOLDER_PATH, big_file_name)

    # Open the big file for writing
      # Iterate over each .txt file in the folder
      Dir.glob(File.join(FOLDER_PATH, '*.txt')).each do |txt_file_path|
        # Get the name of the current file
        File.open(big_file_path, 'a') do |big_file|

        file_name = File.basename(txt_file_path)

        next if file_name.include?("collated")

        # Write the file name as a section header
        big_file.puts("==== #{file_name} ====")

        # Write the content of the current file to the big file

        if File.read(txt_file_path).squeeze.strip.empty?
          File.delete(txt_file_path)
          next
        end

        big_file.puts(File.read(txt_file_path))

        # Add a separator between sections
        big_file.puts("\n\n")
        puts file_name
        File.delete(txt_file_path)
      end
    end
  end

  def transcribe
    @files.each do |file|
      collate
      path = file.first
      puts "using model: #{WHISPER_MODEL}"
      start = Time.now
      `whisper #{path} --model #{WHISPER_MODEL}   --language en --output_format txt --output_dir /Users/markdonahue/Desktop/audios/ --fp16 False`
      finish = Time.now
      puts "transcription took #{finish - start}!"
      File.delete(path)
    end
  end

  def get_files
    files = Dir.glob(File.join(FOLDER_PATH, '*.wav')).map do |file_path|
      next unless File.file?(file_path)  # Skip if not a file

      # Get file creation timestamp
      created_at = File.birthtime(file_path)

      # Print the file name and creation timestamp
      # puts "#{File.basename(file_path)} - Created at: #{created_at}"
      [file_path, created_at]
    end

    files = files.compact
    .reject{|a| a.first.nil?}
    .reject{|a| a.first.include?(".DS_Store")}
    .reject{|a| a.first.include?(".txt")}
    .sort_by{|a| a.last}
    [0..-2]

    files
  end

end

w = Watch.new
w.run

