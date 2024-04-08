


# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
#declared_trivial = github.pr_title.include? "#trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
#warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
#warn("Big PR") if git.lines_of_code > 500

# Don't let testing shortcuts get into master by accident
#fail("fdescribe left in tests") if `grep -r fdescribe specs/ `.length > 1
#fail("fit left in tests") if `grep -r fit specs/ `.length > 1

message("Testing vikas new danger")

# def generate_coverage_message(coverage_file_path)
#     current_dir = Dir.pwd
#     complete_coverage_file_path = "#{current_dir}/#{coverage_file_path}"
#     UI.message "Coverage file path: #{complete_coverage_file_path}"

#     first_term = "class=\"summary-counter\">"
#     second_term = "</div>"

#     begin
#     # Open the file in read mode
#     File.open(complete_coverage_file_path, "r") do |file|
#         # Read the contents of the file
#         file_data = file.read
#         first_string = file_data.split(first_term, -1)[1]
#         final_string = first_string.split(second_term, -1)[0]
#         # Output the contents
#         message = final_string
#     end
#     rescue Errno::ENOENT
#     # Handling for "No such file or directory" error
#     message "File not found. #{complete_coverage_file_path}"
#     return message
#     end
# end  
# coverage_file_path = "fastlane/xcov_output/index.html"
# coverage_message = generate_coverage_message(coverage_file_path)
# message(coverage_message)


def generate_coverage_message(coverage_file_path)
    current_dir = Dir.pwd
    complete_coverage_file_path = "#{current_dir}/#{coverage_file_path}"
    UI.message "Coverage file path: #{complete_coverage_file_path}"
    json_data = File.read(complete_coverage_file_path)
    # Parse JSON
    data = JSON.parse(json_data)

    # Extract coverage value
    coverage = data['coverage']

    # Format coverage value to have only two decimal points
    formatted_coverage = format('%.2f', coverage)

    return "kya bollo bhai #{formatted_coverage}"
end  
coverage_file_path = "fastlane/xcov_output/report.json"
coverage_message = generate_coverage_message(coverage_file_path)
message(coverage_message)