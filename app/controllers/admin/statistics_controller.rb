class Admin::StatisticsController < Admin::AdminController

  layout false
  respond_to :json, :xml

  # GET /admin/statistics/visitors.json
  def visitors
    respond_with Visit.facet_date options_params
  end

  # GET /admin/statistics/professions.json
  def professions
    respond_with Person.facet_profession
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def options_params
      if params[:options]
        params.require(:options).permit(:interval)
      else
        {}
      end
    end
end
