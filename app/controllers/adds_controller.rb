class AddsController < ApplicationController
  # GET /adds
  # GET /adds.json
  def index
    @adds = Add.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @adds }
    end
  end

  # GET /adds/1
  # GET /adds/1.json
  def show
    @add = Add.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @add }
    end
  end

  # GET /adds/new
  # GET /adds/new.json
  def new
    campaign_id = 199420745
    ad_group_name = "cuarto intento con adwords y keywords"

    ################
    ad_name = "prueba 2"
    ad_desc1 = "esto es prueba"
    ad_desc2 = "esto es prueba"
    ad_url = "http://tbf.mx/"
    ad_display = "tbf.mx/"
    ################  
    
  end

  # GET /adds/1/edit
  def edit
    @add = Add.find(params[:id])
  end

  # POST /adds
  # POST /adds.json
  def create
    @add = Add.new(params[:add])
    ###
    #campaign_id = aparams[:add][campaign_id]
     
    ###
    ###
    #campaign_id = aparams[:add][campaign_id]
    #api_v = 
    #ad_group_name
    #ad_name
    
    #campaign_id = session[:active_camp].to_i
    campaign_id = 199420745
    ad_group_name = "cuarto intento con adwords y keywords"
    ###
   
   #genero grupos de anuncios 


  begin
    # Campaign ID to add ad group to.
    
    ad_group_id = add_ad_groups(campaign_id.to_i, get_api_version(), ad_group_name.to_s)

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

  #termina generación de grupo


  #genero el anuncio

  ####
    #ad_group_id = 16273496225
  ####  
    puts "---------------id de grupo-----------------------------------"
    puts ad_group_id.to_i
    puts "-------------------------------------------------------------"
    ################
    ad_name = "prueba 2"
    ad_desc1 = "esto es prueba"
    ad_desc2 = "esto es prueba"
    ad_url = "http://tbf.mx/"
    ad_display = "tbf.mx/"
    ################  

    text_ad_id =""
    begin
      # Ad group ID to add text ads to.
      text_ad_id = add_text_ads(ad_group_id.to_i, ad_name.to_s,ad_desc1, ad_desc2, ad_url, ad_display )
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
    #termina generación el anuncio

    #empiezan las keywords
    #######
    kws = ["hola",  "adios", "es prueba" , "esto de aqui tambien es prueba"] #TODAS LAS KEYWORDS
    #ad_group_id = '16273496225'.to_i
    #######
    begin
    # Ad group ID to add keywords to.
    add_keywords(ad_group_id,kws)

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
    #terminan las keywords
    
  end

  # PUT /adds/1
  # PUT /adds/1.json
  def update
    @add = Add.find(params[:id])

    respond_to do |format|
      if @add.update_attributes(params[:add])
        format.html { redirect_to @add, notice: 'Add was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @add.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adds/1
  # DELETE /adds/1.json
  def destroy
    @add = Add.find(params[:id])
    @add.destroy

    respond_to do |format|
      format.html { redirect_to adds_url }
      format.json { head :no_content }
    end
  end

  private

    

    def add_keywords(ad_group_id,kws)
      # AdwordsApi::Api will read a config file from ENV['HOME']/adwords_api.yml
      # when called without parameters.
      adwords = get_adwords_api()

      #puts adwords.inspect

      # To enable logging of SOAP requests, set the log_level value to 'DEBUG' in
      # the configuration file or provide your own logger:
      # adwords.logger = Logger.new('adwords_xml.log')

      ad_group_criterion_srv = adwords.service(:AdGroupCriterionService, get_api_version())

      #puts ad_group_criterion_srv.inspect

      # Create keywords.
      # The 'xsi_type' field allows you to specify the xsi:type of the object
      # being created. It's only necessary when you must provide an explicit
      # type that the client library can't infer.
     
       
=begin       
          keywords = [
            {:xsi_type => 'BiddableAdGroupCriterion',
              :ad_group_id => ad_group_id,
              :criterion => {
                :xsi_type => 'Keyword',
                :text => 'mars cruise',
                :match_type => 'BROAD'
             }
            },
            {:xsi_type => 'BiddableAdGroupCriterion',
              :ad_group_id => ad_group_id,
              :criterion => {
                :xsi_type => 'Keyword',
                :text => 'space hotel',
                :match_type => 'BROAD'}}
          ]
=end

        keywords = []
        kws.each do |k|
          keywords.push({:xsi_type => 'BiddableAdGroupCriterion',
            :ad_group_id => ad_group_id.to_i,
            :criterion => {
              :xsi_type => 'Keyword',
              :text => k.to_s,
              :match_type => 'BROAD'},
              # Optional fields:
            :user_status => 'PAUSED'
            })
            
        end 
=begin
        puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        puts keywords.inspect
        puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
=end

      # Create 'ADD' operations.
      operations = keywords.map do |keyword|
        {:operator => 'ADD', :operand => keyword}
      end
        puts "-------------------------------------------------------------------------"
        puts operations.inspect
        puts "-------------------------------------------------------------------------"
      # Add keywords.
      response = ad_group_criterion_srv.mutate(operations)

      #puts "6666666666666666666666666666666666666666666666666"
      if response and response[:value]
        ad_group_criteria = response[:value]
        puts "Added %d keywords to ad group ID %d:" %
            [ad_group_criteria.length, ad_group_id]
        ad_group_criteria.each do |ad_group_criterion|
          puts "\tKeyword ID is %d and type is '%s'" %
              [ad_group_criterion[:criterion][:id],
               ad_group_criterion[:criterion][:type]]
        end
      else
        raise StandardError, 'No keywords were added.'
      end
    end


    def add_text_ads(ad_group_id, ad_name,ad_desc1, ad_desc2, ad_url, ad_display )
      # AdwordsApi::Api will read a config file from ENV['HOME']/adwords_api.yml
      # when called without parameters.
      adwords = get_adwords_api()

      # To enable logging of SOAP requests, set the log_level value to 'DEBUG' in
      # the configuration file or provide your own logger:
      # adwords.logger = Logger.new('adwords_xml.log')

      ad_group_ad_srv = adwords.service(:AdGroupAdService, get_api_version())

      # Create text ads.
      # The 'xsi_type' field allows you to specify the xsi:type of the object
      # being created. It's only necessary when you must provide an explicit
      # type that the client library can't infer.
      

      text_ads = [
        {
          :xsi_type => 'TextAd',
          :headline => ad_name.to_s,
          :description1 => ad_desc1.to_s,
          :description2 => ad_desc2.to_s,
          :url => ad_url.to_s,
          :display_url => ad_display.to_s
        }
      ]

      # Create ad 'ADD' operations.
      text_ad_operations = text_ads.map do |text_ad|
        {:operator => 'ADD',
         :operand => {:ad_group_id => ad_group_id, :ad => text_ad}}
      end

      # Add ads.
      aux =""
      response = ad_group_ad_srv.mutate(text_ad_operations)
      if response and response[:value]
        ads = response[:value]
        puts "Added %d ad(s) to ad group ID %d:" % [ads.length, ad_group_id]
        ads.each do |ad|
          puts "\tAd ID %d, type '%s' and status '%s'" %
              [ad[:ad][:id], ad[:ad][:ad_type], ad[:status]]
          aux = ad[:ad][:id]
          return aux
        end
      else
        raise StandardError, 'No ads were added.'
      end


    end


    def add_ad_groups(campaign_id, api_v, ad_name)
    # AdwordsApi::Api will read a config file from ENV['HOME']/adwords_api.yml
    # when called without parameters.
    adwords = get_adwords_api()
    #text
    # To enable logging of SOAP requests, set the log_level value to 'DEBUG' in
    # the configuration file or provide your own logger:
    # adwords.logger = Logger.new('adwords_xml.log')

    ad_group_srv = adwords.service(:AdGroupService, api_v)

    ad_groups = [
      {
        :name => ad_name.to_s,
        :status => 'PAUSED',
        :campaign_id => campaign_id.to_i,
        :bidding_strategy_configuration => {
          :bids => [
            {
              # The 'xsi_type' field allows you to specify the xsi:type of the
              # object being created. It's only necessary when you must provide
              # an explicit type that the client library can't infer.
              :xsi_type => 'CpcBid',
              :bid => {:micro_amount => 10000000}
            }
          ]
        },
        :settings => [
          # Targetting restriction settings - these setting only affect serving
          # for the Display Network.
          {
            :xsi_type => 'TargetingSetting',
            :details => [
              # Restricting to serve ads that match your ad group placements.
              {
                :xsi_type => 'TargetingSettingDetail',
                :criterion_type_group => 'PLACEMENT',
                :target_all => true
              },
              # Using your ad group verticals only for bidding.
              {
                :xsi_type => 'TargetingSettingDetail',
                :criterion_type_group => 'VERTICAL',
                :target_all => false
              }
            ]
          }
        ]
      }

      
    ]

    # Prepare operations for adding ad groups.
    operations = ad_groups.map do |ad_group|
      {:operator => 'ADD', :operand => ad_group}
    end
    #operations = {:operator => 'ADD', :operand => ad_groups}
    puts "-----------------------------------------------------------"
    puts operations.inspect
    puts "-----------------------------------------------------------"
    # Add ad groups.
    aux = ""
    response = ad_group_srv.mutate(operations)
    if response and response[:value]
      response[:value].each do |ad_group|
        puts "Ad group ID %d was successfully added." % ad_group[:id]
        aux = ad_group[:id]
      end
    else
      raise StandardError, 'No ad group was added'
    end

    return aux
  end


end
