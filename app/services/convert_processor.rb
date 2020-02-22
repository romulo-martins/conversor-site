class ConvertProcessor
    attr_reader :erros

    def initialize(convert_process)
        @convert_process = convert_process
        @erros = []
    end

    def execute
        begin
            name = load_name(@convert_process)
            @convert_process.update_attributes(
                status: ConvertProcessStatus::RUNNING,
                name: name 
            )
            convert @convert_process
        rescue => exception
            @erros << exception
            @convert_process.update_attributes(
                status: ConvertProcessStatus::ERROR
            )
        end
    end

    private 

    def convert process
        system("mkdir data")
        system("mkdir data/temp")
        
        name, url, extension = process.name, process.url, process.format
        puts("Download from #{name} ...")
        system("wget -O data/temp/#{name}.html #{url}")

        puts("Converting file #{name} ...")
        system("pandoc -o data/#{name}.epub data/temp/#{name}.html")
        
        if ['mobi', 'pdf'].includes?(extension)
            system("ebook-convert data/#{name}.epub data/#{name}.#{extension}")
            system("rm data/#{name}.epub")
        end

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
