class ConvertProcessorWorker
    include Sidekiq::Worker
  
    def perform(convert_process_id)
        puts 'Processador: executando ...'
        convert_process = ConvertProcess.find(convert_process_id)
        if convert_process
            ConvertProcessor.new(convert_process).execute
            puts 'Processador: concluido!'
        else
            puts 'Erro: processo não encontrado!'
        end
    end
end