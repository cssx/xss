module XSS
  class MemoryFileReader
    def initialize(files)
      @files = files
    end

    def read(file_name)
      @files[file_name]
    end
  end

  class MemoryFileWriter
    def initialize()
      @files = {}
    end

    def write(file_name, content)
      @files[file_name] = content
    end
  end  

  class Compiler
    def initialize(file_reader, file_writer)
      @file_reader = file_reader
      @file_writer = file_writer
    end

    def compile(file_name)
      source = @file_reader.read(file_name)
      parser = Parser.new(source)

      xss_document = parser.parse()
      context = Context.new
      css_document = context.transform(context)
      formatter = Formatter.new()
      css_string = formatter.format(css_document)

      file_writer.write(file_name, css_string)
    end
  end
end
