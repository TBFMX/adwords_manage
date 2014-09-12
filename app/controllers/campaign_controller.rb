class CampaignController < ApplicationController
  require 'adwords_api'
  PAGE_SIZE = 50

  def index()
    @selected_account = selected_account

    if @selected_account
      response = request_campaigns_list()
      if response
        @campaigns = Campaign.get_campaigns_list(response)
        @campaign_count = response[:total_num_entries]
      end
    end
  end

  def list
    
  end
  def show
    
  end

  def new
    
  end
  def destroy
    
  end  

  def create
    #require 'adwords_api'
    @selected_account = selected_account

    puts"-----------------------------------------------------"
    puts params
    puts"-----------------------------------------------------"
    b_name = params[:info][:campaign_name]
    c_name = params[:info][:budget_name]

    adwords = get_adwords_api()
    token = adwords.authorize()
    budget_id = create_budget(adwords,token,b_name)
    create_camp(adwords,token,budget_id ,c_name)
  end 
  def create_budget(adw,tok,b_name)
    puts"-----------------------------------------------------"
    puts adw
    puts tok
    puts b_name
    puts"-----------------------------------------------------"

    adwords = adw
    token = tok
    budget_srv = adwords.service(:BudgetService, get_api_version())
    budget = {
      :name => b_name.to_s,
      :amount => {:micro_amount => 50000000},
      :delivery_method => 'STANDARD',
      :period => 'DAILY'
    }
    puts "1111111111111111"
    budget_operation = {:operator => 'ADD', :operand => budget}
    puts"-----------------------------------------------------"
    puts budget_operation.inspect
    puts"-----------------------------------------------------"
    # Execute the new budget operation and save the assigned budget ID.
    return_budget = budget_srv.mutate([budget_operation])
    puts "22222222222222222222"
    puts"-----------------------------------------------------"
    puts return_budget.inspect
    puts"-----------------------------------------------------"

    budget_id = return_budget[:value].first[:budget_id]
    return budget_id

  end  

  def create_camp(adw,tok,b_id , c_name)
    #api = get_adwords_api()
    #service = api.service(:CampaignService, get_api_version())
    #@aux_camp_view = service
    #budget_id = add_budget(service)
    #########
    require 'adwords_api'

    adwords = get_adwords_api()
    token = adwords.authorize()
    ################
    #// Get the CampaignService.
    campaign_srv = adwords.service(:CampaignService, get_api_version())
    ##########

    puts "33333333333333333333333333333333333333333333333333333333333333"
    ################
 

  budget_id = b_id   
  puts "------------------------------------------"
  puts budget_id
  puts "------------------------------------------"
    # Create campaigns.
  campaign = 
    {
      :name => c_name.to_s,
      :status => 'PAUSED',
      :bidding_strategy_configuration => {
        :bidding_strategy_type => 'MANUAL_CPC'
      },
      # Budget (required) - note only the budget ID is required.
      :budget => {:budget_id => budget_id},
      :advertising_channel_type => 'SEARCH',
      # Optional fields:
      :start_date =>
          DateTime.parse((Date.today + 1).to_s).strftime('%Y%m%d'),
      :ad_serving_optimization_status => 'ROTATE',
      :network_setting => {
        :target_google_search => true,
        :target_search_network => true,
        :target_content_network => true
      },
      :settings => [
        {
          :xsi_type => 'GeoTargetTypeSetting',
          :positive_geo_target_type => 'DONT_CARE',
          :negative_geo_target_type => 'DONT_CARE'
        },
        {
          :xsi_type => 'KeywordMatchSetting',
          :opt_in => true
        }
      ],
      :frequency_cap => {
        :impressions => '5',
        :time_unit => 'DAY',
        :level => 'ADGROUP'
      }
    }
  
  puts "4444444444444444444444444444444444444444444444444444444444444"
    ###########################
    operations = [{:operator => 'ADD', :operand => campaign}]
    puts "5555555555555555555555555555555555555555555555555555555555555"
    #############################

    response = campaign_srv.mutate(operations)
    puts "6666666666666666666666666666666666666666666666666666666666666"
    ############################
    puts "hola"
    if response and response[:value]
      puts "bien"
      response[:value].each do |campaign|
        puts "Campaign with name '%s' and ID %d was added." %
            [campaign[:name], campaign[:id]]
      end
    else
      raise new StandardError, 'No campaigns were added.'
      puts "mal"
    end
    puts "7777777777777777777777777777777777777777777777777777777777777"
    ##############################

    session[:active_camp] = campaign[:id]
  end  
  private

  def request_campaigns_list()
    api = get_adwords_api()
    service = api.service(:CampaignService, get_api_version())
    selector = {
      :fields => ['Id', 'Name', 'Status'],
      :ordering => [{:field => 'Id', :sort_order => 'ASCENDING'}],
      :paging => {:start_index => 0, :number_results => PAGE_SIZE}
    }
    result = nil
    begin
      result = service.get(selector)
    rescue AdwordsApi::Errors::ApiException => e
      logger.fatal("Exception occurred: %s\n%s" % [e.to_s, e.message])
      flash.now[:alert] =
          'API request failed with an error, see logs for details'

      rescue NoMethodError => e
      puts "----------------------------------------------------------------------------------------"
      puts 'hola'
      puts "----------------------------------------------------------------------------------------"
      
      logger.fatal("---------------------------EL PROBLEMA ES : %s\n%s" % [e.to_s, e.message])
      flash.now[:alert] =
          'no se recibio respuesta del API de google, porfavor espere'
    end
    return result
  end

  def add_budget(service)

    # Create a budget, which can be shared by multiple campaigns.
    budget = {
      :name => 'Prueba budget #%d' % (Time.new.to_f * 1000).to_i,
      :amount => {:micro_amount => 50000000},
      :delivery_method => 'STANDARD',
      :period => 'DAILY'
    }
    budget_operation = {:operator => 'ADD', :operand => budget}

    # Execute the new budget operation and save the assigned budget ID.
    return_budget = service.mutate([budget_operation])
    budget_id = return_budget[:value].first[:budget_id]

    return budget_id
  end  
=begin  
  def send(campaign)
    operations = [
    {:operator => 'ADD', :operand => campaign}
    ]
    response = campaign_srv.mutate(operations)
    if response and response[:value]
      response[:value].each do |campaign|
        puts "Campaign with name '%s' and ID %d was added." %
            [campaign[:name], campaign[:id]]
      end
    else
      raise new StandardError, 'No campaigns were added.'
    end
  end
=end  

end
