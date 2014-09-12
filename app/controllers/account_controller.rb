class AccountController < ApplicationController

  def index()
    @selected_account = selected_account
    graph = get_accounts_graph()
    @accounts = Account.get_accounts_map(graph)

  end

  def select()
    self.selected_account = params[:account_id]
    flash[:notice] = "Selected account: %s" % selected_account
    redirect_to home_index_path
  end

  def new

  end  

  def create

  puts params
=begin    
    require 'adwords_api'
    require 'adwords_api/utils'

    @name_u = params[:name]

    adwords = get_adwords_api()
    token = adwords.authorize()
    api_v = :v201406
    begin
    create_account(api_v,adwords,@name_u)
    redirect_to root_path
    # Authorization error.
    rescue AdsCommon::Errors::OAuth2VerificationRequired => e
      puts "Authorization credentials are not valid. Edit adwords_api.yml for " +
          "OAuth2 client ID and secret and run misc/setup_oauth2.rb example " +
          "to retrieve and store OAuth2 tokens."
      puts "See this wiki page for more details:\n\n  " +
          'http://code.google.com/p/google-api-ads-ruby/wiki/OAuth2'

    # HTTP errors.
    rescue AdsCommon::Errors::HttpError => e
      puts "HTTP Error: %s" % e

    # API errors.
    rescue AdwordsApi::Errors::ApiException => e
      puts "Message: %s" % e.message
      puts 'Errors:'
      e.errors.each_with_index do |error, index|
        puts "\tError [%d]:" % (index + 1)
        error.each do |field, value|
          puts "\t\t%s: %s" % [field, value]
        end
      end
    end
=end    
  end 

  def show
  end

  def destroy
  end 

  private

  def create_account(api_v,adw,name_u)
  # AdwordsApi::Api will read a config file from ENV['HOME']/adwords_api.yml
  # when called without parameters.
  adwords = adw

  # To enable logging of SOAP requests, set the log_level value to 'DEBUG' in
  # the configuration file or provide your own logger:
  # adwords.logger = Logger.new('adwords_xml.log')

  managed_customer_srv = adwords.service(:ManagedCustomerService, api_v)

  # Create a local Customer object.
  customer = {
    :name => name_u,
    :currency_code => 'MXN',
    :date_time_zone => 'America/Mexico_City'
  }

  # Prepare operation to create an account.
  operation = {
      :operator => 'ADD',
      :operand => customer
  }

  # Create the account. It is possible to create multiple accounts with one
  # request by sending an array of operations.
  response = managed_customer_srv.mutate([operation])

  response[:value].each do |new_account|
    puts "Account with customer ID '%s' was successfully created." %
        AdwordsApi::Utils.format_id(new_account[:customer_id])
  end
end

  def get_accounts_graph()
    adwords = get_adwords_api()
    service = adwords.service(:ManagedCustomerService, get_api_version())
    selector = {:fields => ['Login', 'CustomerId', 'CompanyName']}
    result = nil
    begin
      result = adwords.use_mcc {service.get(selector)}
    rescue AdwordsApi::Errors::ApiException => e
      logger.fatal("---------------------------EL PROBLEMA ES : %s\n%s" % [e.to_s, e.message])
      flash.now[:alert] =
          'Porfavor valide su informacion de factuaracion ante Google'
    
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
end
