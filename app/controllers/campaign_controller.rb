class CampaignController < ApplicationController

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

  def new
    #api = get_adwords_api()
    #service = api.service(:CampaignService, get_api_version())
    #@aux_camp_view = service
    #budget_id = add_budget(service)
    #########
    adwords = get_adwords_api()
    token = adwords.authorize()
    ################
    #// Get the CampaignService.
    campaign_srv = adwords.service(:CampaignService, get_api_version())
    ##########
    budget_srv = adwords.service(:BudgetService, get_api_version())
    # Create a budget, which can be shared by multiple campaigns.
    budget = {
      :name => 'Interplanetary budget #%d' % (Time.new.to_f * 1000).to_i,
      :amount => {:micro_amount => 50000000},
      :delivery_method => 'STANDARD',
      :period => 'DAILY'
    }
    budget_operation = {:operator => 'ADD', :operand => budget}

    # Execute the new budget operation and save the assigned budget ID.
    return_budget = budget_srv.mutate([budget_operation])
    budget_id = return_budget[:value].first[:budget_id]
    puts "33333333333333333333333333333333333333333333333333333333333333"
    ################
    campaign = {
      :name => "Interplanetary Cruise #%d" % (Time.new.to_f * 1000).to_i,
      :status => 'PAUSED',
      :bidding_strategy_configuration => {
        :bidding_strategy_type => 'MANUAL_CPC'
      },
      :budget => {:budget_id => budget_id},
      :settings => [
        {
          :xsi_type => 'KeywordMatchSetting',
          :opt_in => true
        }
      ]
    }
    puts "4444444444444444444444444444444444444444444444444444444444444"
    #####################
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


    
  end  

  def create
    api = get_adwords_api()
    service = api.service(:CampaignService, get_api_version())

    budget_id = add_budget()

    campaign = {
      :name => "prueba #%d" % (Time.new.to_f * 1000).to_i,
      :status => 'PAUSED',
      :bidding_strategy_configuration => {
        :bidding_strategy_type => 'MANUAL_CPC'
      },
      :budget => {:budget_id => budget_id},
      :settings => [
        {
          :xsi_type => 'KeywordMatchingSetting',
          :opt_in => true
        }
      ]
    }

    send(campaign)
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
