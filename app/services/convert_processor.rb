class ConvertProcessor
    attr_reader :erros

    def initialize(convert_process)
        @convert_process = convert_process
        @erros = []
    end

    def execute
        name = load_name(@convert_process)
        @convert_process.update_attributes(
            status: ConvertProcessStatus::RUNNING,
            name: name 
        )
        convert @convert_process
    end

    private 

    def convert process
        system("mkdir data")
        system("mkdir data/temp")
        
        name, url, extension = process.name, process.url, process.format
        puts("Download from #{name} ...")
        system("wget -O data/temp/#{name}.html #{url}")

        puts("Converting file #{name} ...")
        system("pandoc -o data/#{name}.#{extension} data/temp/#{name}.html")

        process.file.attach(
            io: File.open("data/#{name}.#{extension}"), 
            filename: "#{name}.#{extension}", 
            content_type: "text/#{extension}"
        )

        system("rm data/temp/#{name}.html")
        process.update_attributes(status: ConvertProcessStatus::FINISHED)
    end

    def load_name(process)
        return unless process && process.url
        process.url.split('/').last
    end
end
