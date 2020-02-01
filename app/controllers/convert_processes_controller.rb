class ConvertProcessesController < ApplicationController
    before_action :set_convert_process, only: [:show, :destroy]
  
    def index
      @convert_processes = ConvertProcess.all
    end
  
    def show; end
  
    def new
      @convert_process = ConvertProcess.new
    end
  
    def create
      @convert_process = ConvertProcess.new(
        convert_process_params.merge(status: 'Iniciando')
      )
      if @convert_process.save
        ConvertProcessorWorker.perform_async(@convert_process.id)
        redirect_to @convert_process, notice: 'Processo foi criado com sucesso.'
      else
        flash[:error] = @convert_process.errors
        render :new
      end
    end
  
    def destroy
      @convert_process.destroy
      redirect_to convert_process_url, notice: 'Processo removido com sucesso.'
    end
  
    private
      def set_convert_process
        @convert_process = ConvertProcess.find(params[:id])
      end
  
      def convert_process_params
        params.require(:convert_process).permit(:url, :format)
      end
end