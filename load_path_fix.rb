# Inspired by http://blog.8thlight.com/articles/2007/10/08/micahs-general-guidelines-on-ruby-require .
# To Ruby's load path, append the directories which contain the project's program and class files:
project_root = File.dirname( __FILE__)
['program', 'class', [ 'class', 'class-old']].each {|e| $LOAD_PATH << File.expand_path( File.join( project_root, e))}
project_root = nil
