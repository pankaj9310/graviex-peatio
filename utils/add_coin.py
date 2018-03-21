# -*- coding: utf-8 -*-
#!/usr/bin/env python
import json
import os
from shutil import copyfile
import yaml
import sys

class Config:
	def Load(self, file_name):
		data = open(file_name)
		cfg_json = json.load(data)
		data.close()
		return cfg_json

class Backup:
	def Process(self, cfg_json, folder):
		coin_path = "./Coins/" + cfg_json["name"]
		if not os.path.exists(coin_path):
			os.makedirs(coin_path)
		coin_path_backup = coin_path + "/" + folder
		if not os.path.exists(coin_path_backup):
			os.makedirs(coin_path_backup)
		coin_path_backup_config = coin_path_backup + "/config"
		if not os.path.exists(coin_path_backup_config):
			os.makedirs(coin_path_backup_config)
		copyfile("../config/currencies.yml", coin_path_backup_config + "/currencies.yml")
		copyfile("../config/deposit_channels.yml", coin_path_backup_config + "/deposit_channels.yml")
		copyfile("../config/withdraw_channels.yml", coin_path_backup_config + "/withdraw_channels.yml")
		copyfile("../config/markets.yml", coin_path_backup_config + "/markets.yml")

		coin_path_backup_app = coin_path_backup + "/app"
		if not os.path.exists(coin_path_backup_app):
			os.makedirs(coin_path_backup_app)
		coin_path_backup_app_controllers = coin_path_backup_app + "/controllers"
		if not os.path.exists(coin_path_backup_app_controllers):
			os.makedirs(coin_path_backup_app_controllers)
		coin_path_backup_app_controllers_admin = coin_path_backup_app_controllers + "/admin"
		if not os.path.exists(coin_path_backup_app_controllers_admin):
			os.makedirs(coin_path_backup_app_controllers_admin)
		coin_path_backup_app_controllers_admin_deposits = coin_path_backup_app_controllers_admin + "/deposits"
		if not os.path.exists(coin_path_backup_app_controllers_admin_deposits):
			os.makedirs(coin_path_backup_app_controllers_admin_deposits)
		coin_path_backup_app_controllers_admin_withdraws = coin_path_backup_app_controllers_admin + "/withdraws"
		if not os.path.exists(coin_path_backup_app_controllers_admin_withdraws):
			os.makedirs(coin_path_backup_app_controllers_admin_withdraws)
		coin_path_backup_app_controllers_private = coin_path_backup_app_controllers + "/private"
		if not os.path.exists(coin_path_backup_app_controllers_private):
			os.makedirs(coin_path_backup_app_controllers_private)
		copyfile("../app/controllers/private/assets_controller.rb", coin_path_backup_app_controllers_private + "/assets_controller.rb")
		coin_path_backup_app_controllers_private_deposits = coin_path_backup_app_controllers_private + "/deposits"
		if not os.path.exists(coin_path_backup_app_controllers_private_deposits):
			os.makedirs(coin_path_backup_app_controllers_private_deposits)
		coin_path_backup_app_controllers_private_withdraws = coin_path_backup_app_controllers_private + "/withdraws"
		if not os.path.exists(coin_path_backup_app_controllers_private_withdraws):
			os.makedirs(coin_path_backup_app_controllers_private_withdraws)
		coin_path_backup_app_models = coin_path_backup_app + "/models"
		if not os.path.exists(coin_path_backup_app_models):
			os.makedirs(coin_path_backup_app_models)
		coin_path_backup_app_models_admin = coin_path_backup_app_models + "/admin"
		if not os.path.exists(coin_path_backup_app_models_admin):
			os.makedirs(coin_path_backup_app_models_admin)
		copyfile("../app/models/admin/ability.rb", coin_path_backup_app_models_admin + "/ability.rb")
		coin_path_backup_app_models_deposits = coin_path_backup_app_models + "/deposits"
		if not os.path.exists(coin_path_backup_app_models_deposits):
			os.makedirs(coin_path_backup_app_models_deposits)
		coin_path_backup_app_models_withdraws = coin_path_backup_app_models + "/withdraws"
		if not os.path.exists(coin_path_backup_app_models_withdraws):
			os.makedirs(coin_path_backup_app_models_withdraws)
		coin_path_backup_app_views = coin_path_backup_app + "/views"
		if not os.path.exists(coin_path_backup_app_views):
			os.makedirs(coin_path_backup_app_views)
		coin_path_backup_app_views_admin = coin_path_backup_app_views + "/admin"
		if not os.path.exists(coin_path_backup_app_views_admin):
			os.makedirs(coin_path_backup_app_views_admin)
		coin_path_backup_app_views_admin_deposits = coin_path_backup_app_views_admin + "/deposits"
		if not os.path.exists(coin_path_backup_app_views_admin_deposits):
			os.makedirs(coin_path_backup_app_views_admin_deposits)
		coin_path_backup_app_views_admin_deposits_coins = coin_path_backup_app_views_admin_deposits + "/" + cfg_json["key"] + "s"
		if not os.path.exists(coin_path_backup_app_views_admin_deposits_coins):
			os.makedirs(coin_path_backup_app_views_admin_deposits_coins)
		coin_path_backup_app_views_admin_withdraws = coin_path_backup_app_views_admin + "/withdraws"
		if not os.path.exists(coin_path_backup_app_views_admin_withdraws):
			os.makedirs(coin_path_backup_app_views_admin_withdraws)
		coin_path_backup_app_views_admin_withdraws_coins = coin_path_backup_app_views_admin_withdraws + "/" + cfg_json["key"] + "s"
		if not os.path.exists(coin_path_backup_app_views_admin_withdraws_coins):
			os.makedirs(coin_path_backup_app_views_admin_withdraws_coins)
		coin_path_backup_app_views_private = coin_path_backup_app_views + "/private"
		if not os.path.exists(coin_path_backup_app_views_private):
			os.makedirs(coin_path_backup_app_views_private)
		coin_path_backup_app_views_private_assets = coin_path_backup_app_views_private + "/assets"
		if not os.path.exists(coin_path_backup_app_views_private_assets):
			os.makedirs(coin_path_backup_app_views_private_assets)
		copyfile("../app/views/private/assets/_liability_tabs.html.slim", coin_path_backup_app_views_private_assets + "/_liability_tabs.html.slim")
		copyfile("../app/views/private/assets/index.html.slim", coin_path_backup_app_views_private_assets + "/index.html.slim")
		coin_path_backup_app_views_private_withdraws = coin_path_backup_app_views_private + "/withdraws"
		if not os.path.exists(coin_path_backup_app_views_private_withdraws):
			os.makedirs(coin_path_backup_app_views_private_withdraws)
		coin_path_backup_app_views_private_withdraws_coins = coin_path_backup_app_views_private_withdraws + "/" + cfg_json["key"] + "s"
		if not os.path.exists(coin_path_backup_app_views_private_withdraws_coins):
			os.makedirs(coin_path_backup_app_views_private_withdraws_coins)
		coin_path_backup_config_locales = coin_path_backup_config + "/locales"
		if not os.path.exists(coin_path_backup_config_locales):
			os.makedirs(coin_path_backup_config_locales)
		copyfile("../config/locales/client.en.yml", coin_path_backup_config_locales + "/client.en.yml")
		copyfile("../config/locales/server.en.yml", coin_path_backup_config_locales + "/server.en.yml")
		coin_path_backup_spec = coin_path_backup + "/spec"
		if not os.path.exists(coin_path_backup_spec):
			os.makedirs(coin_path_backup_spec)
		coin_path_backup_spec = coin_path_backup + "/spec"
		if not os.path.exists(coin_path_backup_spec):
			os.makedirs(coin_path_backup_spec)
		coin_path_backup_spec_controllers = coin_path_backup_spec + "/controllers"
		if not os.path.exists(coin_path_backup_spec_controllers):
			os.makedirs(coin_path_backup_spec_controllers)
		coin_path_backup_spec_controllers_private = coin_path_backup_spec_controllers + "/private"
		if not os.path.exists(coin_path_backup_spec_controllers_private):
			os.makedirs(coin_path_backup_spec_controllers_private)
		copyfile("../spec/controllers/private/assets_controller_spec.rb", coin_path_backup_spec_controllers_private + "/assets_controller_spec.rb")
		coin_path_backup_public = coin_path_backup + "/public"
		if not os.path.exists(coin_path_backup_public):
			os.makedirs(coin_path_backup_public)
		coin_path_backup_public_templates = coin_path_backup_public + "/templates"
		if not os.path.exists(coin_path_backup_public_templates):
			os.makedirs(coin_path_backup_public_templates)
		coin_path_backup_public_templates_funds = coin_path_backup_public_templates + "/funds"
		if not os.path.exists(coin_path_backup_public_templates_funds):
			os.makedirs(coin_path_backup_public_templates_funds)
		copyfile("../public/templates/funds/deposit.html", coin_path_backup_public_templates_funds + "/deposit.html")
		copyfile("../public/templates/funds/withdraw.html", coin_path_backup_public_templates_funds + "/withdraw.html")
		coin_path_backup_spec_fixtures = coin_path_backup_spec + "/fixtures"
		if not os.path.exists(coin_path_backup_spec_fixtures):
			os.makedirs(coin_path_backup_spec_fixtures)
		copyfile("../spec/fixtures/deposit_channels.yml", coin_path_backup_spec_fixtures + "/deposit_channels.yml")
		copyfile("../spec/fixtures/withdraw_channels.yml", coin_path_backup_spec_fixtures + "/withdraw_channels.yml")
		coin_path_backup_app_assets = coin_path_backup_app + "/assets"
		if not os.path.exists(coin_path_backup_app_assets):
			os.makedirs(coin_path_backup_app_assets)
		coin_path_backup_app_assets_javascripts = coin_path_backup_app_assets + "/javascripts"
		if not os.path.exists(coin_path_backup_app_assets_javascripts):
			os.makedirs(coin_path_backup_app_assets_javascripts)
		coin_path_backup_app_assets_javascripts_funds = coin_path_backup_app_assets_javascripts + "/funds"
		if not os.path.exists(coin_path_backup_app_assets_javascripts_funds):
			os.makedirs(coin_path_backup_app_assets_javascripts_funds)
		coin_path_backup_app_assets_javascripts_funds_models = coin_path_backup_app_assets_javascripts_funds + "/models"
		if not os.path.exists(coin_path_backup_app_assets_javascripts_funds_models):
			os.makedirs(coin_path_backup_app_assets_javascripts_funds_models)
		copyfile("../app/assets/javascripts/funds/models/withdraw.js.coffee", coin_path_backup_app_assets_javascripts_funds_models + "/withdraw.js.coffee")
		coin_path_backup_app_assets_stylesheets = coin_path_backup_app_assets + "/stylesheets"
		if not os.path.exists(coin_path_backup_app_assets_stylesheets):
			os.makedirs(coin_path_backup_app_assets_stylesheets)
		copyfile("../app/assets/stylesheets/market.css.scss", coin_path_backup_app_assets_stylesheets + "/market.css.scss")
                coin_path_backup_app_assets_javascripts_locales = coin_path_backup_app_assets_javascripts + "/locales"
                if not os.path.exists(coin_path_backup_app_assets_javascripts_locales):
                        os.makedirs(coin_path_backup_app_assets_javascripts_locales)
                copyfile("../app/assets/javascripts/locales/en.js.erb", coin_path_backup_app_assets_javascripts_locales + "/en.js.erb")


class Update:
	def Process(self, cfg_json, folder):
		coin_update_path = "./Coins/" + cfg_json["name"] + "/" + folder
		coin_update_path_config = coin_update_path + "/config"
		id = 0
		dep_id = 0
		with_id = 0
		mark_code = 0
		with open(coin_update_path_config + "/currencies.yml", "r+") as curr_f:
			currDataMap = yaml.safe_load(curr_f)
			#print currDataMap[len(currDataMap)-1]['id']
			id = currDataMap[len(currDataMap)-1]['id'] + 1
			curr_f.write("- id: " + str(id) + "\n")
			curr_f.write("  key: " + cfg_json["key"] + "\n")
			curr_f.write("  code: " + cfg_json["code"] + "\n")
			curr_f.write("  symbol: \"" + cfg_json["symbol"] + "\"" + "\n")
			curr_f.write("  coin: " + cfg_json["coin"] + "\n")
			curr_f.write("  quick_withdraw_max: 0" + "\n")
                        curr_f.write("  withdraw_limit: " + cfg_json["withdraw_limit"] + "\n")
			curr_f.write("  withdraw_day_limit: " + cfg_json["withdraw_day_limit"] + "\n")
			curr_f.write("  rpc: " + cfg_json["rpc"] + "\n")
			curr_f.write("  proto: " + cfg_json["proto"] + "\n")
			curr_f.write("  blockchain: " + cfg_json["blockchain"] + "\n")
			curr_f.write("  address_url: " + cfg_json["address_url"] + "\n")
                        curr_f.write("  home: " + cfg_json["home"] + "\n")
                        curr_f.write("  btt: " + cfg_json["btt"] + "\n")
                        curr_f.write("  be: " + cfg_json["be"] + "\n")
			curr_f.write("  assets:" + "\n")
			curr_f.write("    accounts:" + "\n")
			curr_f.write("      -" + "\n")
			curr_f.write("        address: " + cfg_json["address"] + "\n")
		with open(coin_update_path_config + "/deposit_channels.yml", "r+") as dep_f:
			currDataMap = yaml.safe_load(dep_f)
			dep_id = currDataMap[len(currDataMap)-1]['id'] + 200
			dep_f.write("- id: " + str(dep_id) + "\n")
			dep_f.write("  key: " + cfg_json["key"] + "\n")
			dep_f.write("  currency: " + cfg_json["code"] + "\n")
			dep_f.write("  min_confirm: " + cfg_json["min_confirm"] + "\n")
			dep_f.write("  max_confirm: " + cfg_json["max_confirm"] + "\n")
		with open(coin_update_path_config + "/withdraw_channels.yml", "r+") as with_f:
			currDataMap = yaml.safe_load(with_f)
			with_id = currDataMap[len(currDataMap)-1]['id'] + 200
			with_f.write("- id: " + str(with_id) + "\n")
			with_f.write("  key: " + cfg_json["key"] + "\n")
			with_f.write("  currency: " + cfg_json["code"] + "\n")
			with_f.write("  fixed: " + cfg_json["withdraw_fixed"] + "\n")
			with_f.write("  max: " + cfg_json["withdraw_max"] + "\n")
			with_f.write("  fee: " + cfg_json["withdraw_fee"] + "\n")
			with_f.write("  inuse: true" + "\n")
			with_f.write("  type: " + cfg_json["withdraw_type"] + "\n")
		with open(coin_update_path_config + "/markets.yml", "r+") as mark_f:
			currDataMap = yaml.safe_load(mark_f)
			mark_code = currDataMap[len(currDataMap)-1]['code'] + 1
			mark_f.write("- id: " + cfg_json["markets_id"] + "\n")
			mark_f.write("  code: " + str(mark_code) + "\n")
			mark_f.write("  name: " + cfg_json["markets_name"] + "\n")
			mark_f.write("  base_unit: " + cfg_json["markets_base_unit"] + "\n")
			mark_f.write("  quote_unit: " + cfg_json["markets_quote_unit"] + "\n")
			mark_f.write("  #price_group_fixed: 0" + "\n")
			mark_f.write("  bid: {fee: " + cfg_json["markets_bit_fee"] + ", currency: " 
				+ cfg_json["markets_quote_unit"] + ", fixed: " + cfg_json["markets_bit_fixed"] + "}\n")
			mark_f.write("  ask: {fee: " + cfg_json["markets_ask_fee"] + ", currency: " 
				+ cfg_json["markets_base_unit"] + ", fixed: " + cfg_json["markets_ask_fixed"] + "}\n")
			mark_f.write("  sort_order: " + cfg_json["sort_order"] +  "\n")
			mark_f.write("  visible: false" + "\n")
		with open(coin_update_path + "/app/controllers/admin/deposits/" + cfg_json["key"] + "s_controller.rb", "w+") as adm_dep_ctrl_f:
			adm_dep_ctrl_f.write("module Admin\n")
			adm_dep_ctrl_f.write("  module Deposits\n")
			adm_dep_ctrl_f.write("    class " + cfg_json["name"] + "sController < ::Admin::Deposits::BaseController\n")
			adm_dep_ctrl_f.write("      load_and_authorize_resource :class => \'::Deposits::" + cfg_json["name"] + "\'\n\n")
			adm_dep_ctrl_f.write("      def index\n")
			adm_dep_ctrl_f.write("        start_at = DateTime.now.ago(60 * 60 * 24 * 365)\n")
			adm_dep_ctrl_f.write("        @" + cfg_json["key"] + "s = @" + cfg_json["key"] + "s.includes(:member).\n")
			adm_dep_ctrl_f.write("          where('created_at > ?', start_at).\n")
			adm_dep_ctrl_f.write("          order('id DESC').page(params[:page]).per(20)\n")
			adm_dep_ctrl_f.write("      end\n\n")
			adm_dep_ctrl_f.write("      def update\n")
			adm_dep_ctrl_f.write("        @" + cfg_json["key"] + ".accept! if @" + cfg_json["key"] + ".may_accept?\n")
			adm_dep_ctrl_f.write("        redirect_to :back, notice: t('.notice')\n")
			adm_dep_ctrl_f.write("      end\n")
			adm_dep_ctrl_f.write("    end\n")
			adm_dep_ctrl_f.write("  end\n")
			adm_dep_ctrl_f.write("end\n")
		with open(coin_update_path + "/app/controllers/admin/withdraws/" + cfg_json["key"] + "s_controller.rb", "w+") as adm_with_ctrl_f:
			adm_with_ctrl_f.write("module Admin\n")
			adm_with_ctrl_f.write("  module Withdraws\n")
			adm_with_ctrl_f.write("    class " + cfg_json["name"] + "sController < ::Admin::Withdraws::BaseController\n")
			adm_with_ctrl_f.write("      load_and_authorize_resource :class => \'::Withdraws::" + cfg_json["name"] + "\'\n\n")
			adm_with_ctrl_f.write("      def index\n")
			adm_with_ctrl_f.write("        start_at = DateTime.now.ago(60 * 60 * 24 * 3)\n")
			adm_with_ctrl_f.write("        @one_" + cfg_json["key"] + "s = @" + cfg_json["key"] + "s.with_aasm_state(:almost_done).order(\"id DESC\")\n")
			adm_with_ctrl_f.write("        @all_" + cfg_json["key"] + "s = @" + cfg_json["key"] + "s.without_aasm_state(:almost_done).where('created_at > ?', start_at).order(\"id DESC\")\n")
			adm_with_ctrl_f.write("      end\n\n")
			adm_with_ctrl_f.write("      def show\n")
			adm_with_ctrl_f.write("      end\n\n")
			adm_with_ctrl_f.write("      def update\n")
			adm_with_ctrl_f.write("        @" + cfg_json["key"] + ".process!\n")
			adm_with_ctrl_f.write("        redirect_to :back, notice: t('.notice')\n")
			adm_with_ctrl_f.write("      end\n\n")
			adm_with_ctrl_f.write("      def destroy\n")
			adm_with_ctrl_f.write("        @" + cfg_json["key"] + ".reject!\n")
			adm_with_ctrl_f.write("        redirect_to :back, notice: t('.notice')\n")
			adm_with_ctrl_f.write("      end\n")
			adm_with_ctrl_f.write("    end\n")
			adm_with_ctrl_f.write("  end\n")
			adm_with_ctrl_f.write("end\n")
		asset_ctrl_f_data = None
		with open(coin_update_path + "/app/controllers/private/assets_controller.rb", "r") as asset_ctrl_f:
			asset_ctrl_f_data = asset_ctrl_f.read();
		asset_ctrl_f_data_new = asset_ctrl_f_data.replace("#proof", "@" + cfg_json["code"] + "_proof   = Proof.current :"  + cfg_json["code"] +  "\n      #proof");
		asset_ctrl_f_data_new = asset_ctrl_f_data_new.replace("#account", "@" + cfg_json["code"] + "_account = current_user.accounts.with_currency(:"  + cfg_json["code"] +  ").first\n        #account");
		with open(coin_update_path + "/app/controllers/private/assets_controller.rb", "w") as asset_ctrl_f:
			asset_ctrl_f.write(asset_ctrl_f_data_new)
		with open(coin_update_path + "/app/controllers/private/deposits/" + cfg_json["key"] + "s_controller.rb", "w+") as prv_dep_ctrl_f:
			prv_dep_ctrl_f.write("module Private\n")
			prv_dep_ctrl_f.write("  module Deposits\n")
			prv_dep_ctrl_f.write("    class " + cfg_json["name"] + "sController < ::Private::Deposits::BaseController\n")
			prv_dep_ctrl_f.write("      include ::Deposits::CtrlCoinable\n")
			prv_dep_ctrl_f.write("    end\n")
			prv_dep_ctrl_f.write("  end\n")
			prv_dep_ctrl_f.write("end\n")
		with open(coin_update_path + "/app/controllers/private/withdraws/" + cfg_json["key"] + "s_controller.rb", "w+") as prv_with_ctrl_f:
			prv_with_ctrl_f.write("module Private\n")
			prv_with_ctrl_f.write("  module Withdraws\n")
			prv_with_ctrl_f.write("    class " + cfg_json["name"] + "sController < ::Private::Withdraws::BaseController\n")
			prv_with_ctrl_f.write("      include ::Withdraws::Withdrawable\n")
			prv_with_ctrl_f.write("    end\n")
			prv_with_ctrl_f.write("  end\n")
			prv_with_ctrl_f.write("end\n")
		ability_f_data = None
		with open(coin_update_path + "/app/models/admin/ability.rb", "r") as ability_f:
			ability_f_data = ability_f.read();
		ability_f_data_new = ability_f_data.replace("#deposit", "can :manage, ::Deposits::" + cfg_json["name"] + "\n      #deposit")
		ability_f_data_new = ability_f_data_new.replace("#withdraw", "can :manage, ::Withdraws::" + cfg_json["name"] + "\n      #withdraw")
		with open(coin_update_path + "/app/models/admin/ability.rb", "w") as ability_f:
			ability_f.write(ability_f_data_new)
		with open(coin_update_path + "/app/models/deposits/" + cfg_json["key"] + ".rb", "w+") as app_mod_dep_f:
			app_mod_dep_f.write("module Deposits\n")
			app_mod_dep_f.write("  class " + cfg_json["name"] + " < ::Deposit\n")
			app_mod_dep_f.write("    include ::AasmAbsolutely\n")
			app_mod_dep_f.write("    include ::Deposits::Coinable\n\n")
			app_mod_dep_f.write("    validates_uniqueness_of :txout, scope: :txid\n")
			app_mod_dep_f.write("  end\n")
			app_mod_dep_f.write("end\n")
		with open(coin_update_path + "/app/models/withdraws/" + cfg_json["key"] + ".rb", "w+") as app_mod_with_f:
			app_mod_with_f.write("module Withdraws\n")
			app_mod_with_f.write("  class " + cfg_json["name"] + " < ::Withdraw\n")
			app_mod_with_f.write("    include ::AasmAbsolutely\n")
			app_mod_with_f.write("    include ::Withdraws::Coinable\n")
			app_mod_with_f.write("    include ::FundSourceable\n")
			app_mod_with_f.write("  end\n")
			app_mod_with_f.write("end\n")
		with open(coin_update_path + "/app/views/admin/deposits/" + cfg_json["key"] + "s/index.html.slim", "w+") as app_v_adm_dep_f:
			app_v_adm_dep_f.write("= table_for(@" + cfg_json["key"] + "s, class: 'table table-condensed table-hover') do |t|\n")
			app_v_adm_dep_f.write("  - t.column :txid do |x|\n")
			app_v_adm_dep_f.write("    a href='#{x.blockchain_url}' target='_blank'\n")
			app_v_adm_dep_f.write("      code.text-info = x.txid.truncate(36)\n")
			app_v_adm_dep_f.write("  - t.column :created_at\n")
			app_v_adm_dep_f.write("  - t.column :currency_obj_key_text\n")
			app_v_adm_dep_f.write("  - t.column :member_name do |x|\n")
			app_v_adm_dep_f.write("    = link_to x.member_name, url_for([:admin, x.member]), target: '_blank'\n")
			app_v_adm_dep_f.write("  - t.column :amount do |x|\n")
			app_v_adm_dep_f.write("    code.text-info = x.amount\n")
			app_v_adm_dep_f.write("  - t.column :confirmations do |x|\n")
			app_v_adm_dep_f.write("    span.badge = x.confirmations\n")
			app_v_adm_dep_f.write("  - t.column :state_and_actions do |x|\n")
			app_v_adm_dep_f.write("    span = x.aasm_state_text\n")
			app_v_adm_dep_f.write("    - if x.may_accept?\n")
			app_v_adm_dep_f.write("      span = ' / '\n")
			app_v_adm_dep_f.write("      = link_to t('.accept'), url_for([:admin, x]), method: 'PATCH', confirm: t('.accept_confirm')\n\n")
			app_v_adm_dep_f.write(".pull-right = paginate @" + cfg_json["key"] + "s\n")
		with open(coin_update_path + "/app/views/admin/withdraws/" + cfg_json["key"] + "s//_table.html.slim", "w+") as app_v_adm_with_f:
			app_v_adm_with_f.write("= table_for(" + cfg_json["key"] + "s, class: 'table table-condensed table-hover', model: Withdraws::" + cfg_json["name"] + ") do |t|\n")
			app_v_adm_with_f.write("  - t.column :id, class: 'col-xs-2'\n")
			app_v_adm_with_f.write("  - t.column :created_at, class: 'col-xs-3'\n")
			app_v_adm_with_f.write("  - t.column :currency_obj_key_text, class: 'col-xs-2'\n")
			app_v_adm_with_f.write("  - t.column :member_name, class: 'col-xs-3' do |x|\n")
			app_v_adm_with_f.write("    = link_to x.member_name, url_for([:admin, x.member]), target: '_blank'\n")
			app_v_adm_with_f.write("  - t.column :fund_source, class: 'col-xs-6' do |x|\n")
			app_v_adm_with_f.write("    span #{x.fund_extra} # #{x.fund_uid.truncate(40)}\n")
			app_v_adm_with_f.write("  - t.column :amount, class: 'col-xs-3' do |x|\n")
			app_v_adm_with_f.write("    code.text-info = x.amount\n")
			app_v_adm_with_f.write("  - t.column :state_and_action, class: 'col-xs-3' do |x|\n")
			app_v_adm_with_f.write("    span = \"#{x.aasm_state_text} / \"\n")
			app_v_adm_with_f.write("    = link_to t(\"actions.view\"), url_for([:admin, x]), target: '_blank'")
		with open(coin_update_path + "/app/views/admin/withdraws/" + cfg_json["key"] + "s/index.html.slim", "w+") as app_v_adm_with_f:
			app_v_adm_with_f.write("- unless @one_" + cfg_json["key"] + "s.empty?\n")
			app_v_adm_with_f.write("  .panel.panel-primary\n")
			app_v_adm_with_f.write("    .panel-heading: span = t('.one')\n")
			app_v_adm_with_f.write("    = render partial: 'table', locals: {" + cfg_json["key"] + "s: @one_" + cfg_json["key"] + "s}\n")
			app_v_adm_with_f.write("- unless @all_" + cfg_json["key"] + "s.empty?\n")
			app_v_adm_with_f.write("  .panel.panel-success\n")
			app_v_adm_with_f.write("    .panel-heading: span = t('.all')\n")
			app_v_adm_with_f.write("    = render partial: 'table', locals: {" + cfg_json["key"] + "s: @all_" + cfg_json["key"] + "s}\n\n")
			app_v_adm_with_f.write("- if @all_" + cfg_json["key"] + "s.empty? and @one_" + cfg_json["key"] + "s.empty?\n")
			app_v_adm_with_f.write("  h3.text-info.text-center = t('.empty')\n")
		with open(coin_update_path + "/app/views/admin/withdraws/" + cfg_json["key"] + "s/show.html.slim", "w+") as app_v_adm_with_f:
			app_v_adm_with_f.write(".row\n")
			app_v_adm_with_f.write("  .col-xs-12\n")
			app_v_adm_with_f.write("    .panel.panel-primary\n")
			app_v_adm_with_f.write("      .panel-heading\n")
			app_v_adm_with_f.write("        span = t('.withdraw', sn: @" + cfg_json["key"] + ".id)\n")
			app_v_adm_with_f.write("      .panel-body\n")
			app_v_adm_with_f.write("        = description_for :withdraw do\n")
			app_v_adm_with_f.write("          = item_for @" + cfg_json["key"] + ", :id\n")
			app_v_adm_with_f.write("          = item_for @" + cfg_json["key"] + ", :created_at\n")
			app_v_adm_with_f.write("          = item_for @" + cfg_json["key"] + ", :aasm_state_text\n")
			app_v_adm_with_f.write("          hr.split\n")
			app_v_adm_with_f.write("          = item_for @" + cfg_json["key"] + ".member, :name\n")
			app_v_adm_with_f.write("          = item_for @" + cfg_json["key"] + ", :fund_extra\n")
			app_v_adm_with_f.write("          = item_for @" + cfg_json["key"] + ", :fund_uid do\n")
			app_v_adm_with_f.write("            span = @" + cfg_json["key"] + ".fund_uid.truncate(40)\n")
			app_v_adm_with_f.write("          = item_for @" + cfg_json["key"] + ", :amount\n")
			app_v_adm_with_f.write("          hr.split\n")
			app_v_adm_with_f.write("          = item_for @" + cfg_json["key"] + ", :remark\n")
			app_v_adm_with_f.write("          hr.split\n")
			app_v_adm_with_f.write("          ul.list-inline.pull-right\n")
			app_v_adm_with_f.write("            - if @" + cfg_json["key"] + ".may_reject?\n")
			app_v_adm_with_f.write("              li\n")
			app_v_adm_with_f.write("                = link_to t('.reject'), url_for([:admin, @" + cfg_json["key"] + "]), class: 'btn btn-danger', method: 'DELETE', confirm: t('.reject_confirm')\n")
			app_v_adm_with_f.write("            - if @" + cfg_json["key"] + ".may_process?\n")
			app_v_adm_with_f.write("              li\n")
			app_v_adm_with_f.write("                = link_to t('.process'), url_for([:admin, @" + cfg_json["key"] + "]), class: 'btn btn-primary', method: 'PATCH'\n\n")
			app_v_adm_with_f.write("  .col-xs-12\n")
			app_v_adm_with_f.write("    = render partial: 'shared/admin/member', locals: {member: @" + cfg_json["key"] + ".member}\n")
			app_v_adm_with_f.write("    = render partial: 'shared/admin/account', locals: {account: @" + cfg_json["key"] + ".account}\n")
		with open(coin_update_path + "/app/views/private/assets/_" + cfg_json["code"] + "_assets.html.slim", "w+") as f:
			f.write(".panel.panel-default\n")
			f.write("  .panel-body\n")
			f.write("    .row\n")
			f.write("      #guide.col-xs-8\n")
			f.write("        h3 = t('.title')\n")
			f.write("        p.text-ignore = t('.intro')\n")
			f.write("      #content.col-xs-16\n")
			f.write("        .jumbotron\n")
			f.write("          .row\n")
			f.write("            .col-xs-offset-4.col-xs-16\n")
			f.write("              span.pull-left = t('.total')\n")
			f.write("              span.pull-right\n")
			f.write("                == t(\"currency.icon." + cfg_json["code"] + "\")\n")
			f.write("                = @" + cfg_json["code"] + "_proof.asset_sum\n")
			f.write("          .clearfix\n")
			f.write("          .row\n") 
			f.write("            table.table\n") 
			f.write("              thead\n") 
			f.write("                tr\n") 
			f.write("                  td\n") 
			f.write("                    = t('.address')\n") 
			f.write("                  td\n") 
			f.write("                    = t('.balance')\n") 
			f.write("              tbody\n") 
			f.write("                - @" + cfg_json["code"] + "_proof.addresses.each do |entry|\n") 
			f.write("                  tr\n") 
			f.write("                    td\n") 
			f.write("                      = link_to entry['address'], @" + cfg_json["code"] + "_proof.address_url(entry['address'])\n") 
			f.write("                    td\n") 
			f.write("                      = entry['balance']\n") 
		liab_f_data = None
		with open(coin_update_path + "/app/views/private/assets/_liability_tabs.html.slim", "r") as f:
			liab_f_data = f.read();
		liab_f_data_new = liab_f_data.replace("/li", "li: a." + cfg_json["code"] + "-proof href=\"#" + cfg_json["code"] + "-proof\" data-toggle=\"tab\" == t('.verify-" + cfg_json["code"] + "')\n    /li")
		liab_f_data_new = liab_f_data_new + "    #" + cfg_json["code"] + "-proof.tab-pane:        .trade-wrapper\n"
		liab_f_data_new = liab_f_data_new + "      .assets\n"
		liab_f_data_new = liab_f_data_new + "        span.title = t('." + cfg_json["code"] + "-assets-total')\n"
		liab_f_data_new = liab_f_data_new + "        span.currency\n"
		liab_f_data_new = liab_f_data_new + "          == t(\"currency.icon." + cfg_json["code"] + "\")\n"
		liab_f_data_new = liab_f_data_new + "          = @" + cfg_json["code"] + "_proof.sum\n"
		liab_f_data_new = liab_f_data_new + "      = render 'liability_data', account: @" + cfg_json["code"] + "_account, proof: @" + cfg_json["code"] + "_proof\n"
		with open(coin_update_path + "/app/views/private/assets/_liability_tabs.html.slim", "w") as f:
			f.write(liab_f_data_new)
		file_data = None
		with open(coin_update_path + "/app/views/private/assets/index.html.slim", "r") as f:
			file_data = f.read();
		pos = file_data.find("/li")
		if pos == -1:
			raise Exception("Not found /li /app/views/private/assets/index.html.slim")
		data_id = int(file_data[pos + 3 : file_data.find(" ", pos)])
		data_id = data_id + 1
		tag_str = "/li" + str(data_id-1)
		file_data_new = file_data.replace(tag_str, "li        data-scroll-nav='" + str(data_id) + "'\n        a = t('." + cfg_json["code"] + "-assets')\n" + "/li" + str(data_id) + "\n")
		file_data_new = file_data_new.replace("/div", "    div data-scroll-index=" + str(data_id) + " = render '" + cfg_json["code"] + "_assets'\n/div")
		with open(coin_update_path + "/app/views/private/assets/index.html.slim", "w") as f:
			f.write(file_data_new)
		with open(coin_update_path + "/app/views/private/withdraws/" + cfg_json["key"] + "s/edit.html.slim", "w+") as f:
			f.write("- defaults = {as: :display, required: false, hint: false}\n")
			f.write("= simple_form_for @withdraw, as: :withdraw, defaults: defaults, scope: :" + cfg_json["key"] + " do |f|\n")
			f.write("  = f.input :fund_extra\n")
			f.write("  = f.input :fund_uid\n")
			f.write("  = f.input :sum\n")
			f.write("  = f.input :fee\n")
			f.write("  = f.input :amount\n\n")
			f.write("  - if @withdraw.may_submit?\n")
			f.write("    = two_factor_tag(current_user)\n")
			f.write("    hr.split\n")
			f.write("    = f.button :wrapped, t('actions.confirm') do\n")
			f.write("      = link_to t('actions.cancel'), url_for(@withdraw), role: 'button', class: 'btn btn-danger btn-lg pull-right', method: :delete\n")
		with open(coin_update_path + "/app/views/private/withdraws/" + cfg_json["key"] + "s/new.html.slim", "w+") as f:
			f.write("= simple_form_for @withdraw, as: :withdraw, scope: :" + cfg_json["key"] + " do |f|\n\n")
  			f.write("= f.input :fund_source,\n")
			f.write("    label: t('.fund_source_label'),\n")
			f.write("    collection: @fund_sources,\n")
			f.write("    label_method: :label,\n")
			f.write("    include_blank: false,\n")
			f.write("    hint: link_to(t('.manage_fund_source'), url_for([@channel.currency, :fund_sources]))\n\n")
			f.write("  = f.input :account_balance, as: :display\n")
			f.write("  = f.input :sum do\n")
			f.write("    .input-group\n")
			f.write("      = f.input_field :sum, as: :decimal\n")
			f.write("      .input-group-btn\n")
			f.write("        button#withdraw_all_btn.btn.btn-success type='button' = t('.allin')\n\n")
			f.write("  hr.split\n")
			f.write("  = f.button :wrapped, t('actions.submit'), cancel: withdraws_path\n\n")
			f.write("= content_for :after\n")
  			f.write("= panel do\n")
			f.write("    = table_for(@assets, class: 'table table-condensed table-hover', model: @model) do |t|\n")
			f.write("      - t.column :id, class: 'col-xs-2'\n")
			f.write("      - t.column :created_at, class: 'col-xs-4'\n")
			f.write("      - t.column :fund_uid, class: 'col-xs-10' do |x|\n")
			f.write("        span = \"#{x.fund_extra} @ \"\n")
			f.write("        code.text-info = x.fund_uid\n")
			f.write("      - t.column :amount, class: 'col-xs-2'\n")
			f.write("      - t.column :fee, class: 'col-xs-2'\n")
			f.write("      - t.column :state_and_action, class: 'col-xs-4' do |x|\n")
			f.write("        - if x.cancelable?\n")
			f.write("          span = \"#{x.aasm_state_text} / \"\n")
			f.write("          = link_to t('actions.cancel'), url_for([x]), method: :delete\n")
			f.write("        - else\n")
			f.write("          span = x.aasm_state_text\n\n")
			f.write("= content_for :scripts\n")
  			f.write("  javascript:\n")
			f.write("    $(function() {\n")
			f.write("      $('button#withdraw_all_btn').on('click', function() {\n")
			f.write("        $('input#withdraw_sum').val($('.withdraw_" + cfg_json["key"] + "_account_balance span').text());\n")
			f.write("      });\n")
			f.write("    });\n")
		file_data = None
		with open(coin_update_path + "/config/locales/client.en.yml", "r") as f:
			file_data = f.read();
		pos = file_data.find("#funds")
		if pos == -1:
			raise Exception("Not found #funds /config/locales/client.en.yml")
		file_data_new = file_data.replace("#funds", cfg_json["code"] + ": " + cfg_json["code_name"] + "\n        #funds")
		file_data_new = file_data_new.replace("#deposit", "deposit_" + cfg_json["code"] + ":\n        title: " + cfg_json["code_name"] + " Deposit\n\n      #deposit")
		file_data_new = file_data_new.replace("#withdraw", "withdraw_" + cfg_json["code"] + ":\n        title: " + cfg_json["code_name"] + " Withdraw\n\n      #withdraw")
                file_data_new = file_data_new.replace("#limit", "withdraw_limit_" + cfg_json["code"] + ": Withdraw day limit is " + cfg_json["withdraw_day_limit"] + " for an unverified account.\n        #limit")
		file_data_new = file_data_new.replace("#market", cfg_json["code"] + ": " + cfg_json["code_name"] + " Market\n        #market")
		with open(coin_update_path + "/config/locales/client.en.yml", "w") as f:
			f.write(file_data_new)
		file_data = None
		with open(coin_update_path + "/config/locales/server.en.yml", "r") as f:
			file_data = f.read();
		file_data_new = file_data.replace("#models", "withdraws/" + cfg_json["key"] + ": Withdraw\n      #models")
		file_data_new = file_data_new.replace("#dposits", "deposits/" + cfg_json["key"] + ":\n        created_at: Created At\n        txid: Transaction ID\n        amount: Amount\n        confirmations: Confirmation\n        aasm_state_text: State\n      #dposits")
		file_data_new = file_data_new.replace("#withdraws1", "withdraws/" + cfg_json["key"] + ":\n        id: ID\n        member_name: Account\n        currency_obj_key_text: Currency\n        state_and_actions: State/Action\n        fund_extra_text: Withdraw Label\n        fund_extrat: Withdraw Label\n        fund_source: Bank\n        fund_uid: Account\n        created_at: Created At\n        sum: Amount\n        amount: Amount\n        remark: Remark\n        fee: Fee\n      #withdraws1")
		file_data_new = file_data_new.replace("#address", cfg_json["key"] + "_ismine: Used Address\n              " + cfg_json["key"] + "_invalid: Invalid Address\n              #address")
		file_data_new = file_data_new.replace("#withdraws_msg1", "withdraws/" + cfg_json["key"] + ":\n          attributes:\n            fund_uid:\n              blank: Please enter your withdrawal address\n              invalid: Invalid withdrawals address, please review.\n              ismine: Please use a new address.\n        #withdraws_msg1")
		file_data_new = file_data_new.replace("#market1", cfg_json["code"] + ": " + cfg_json["code_name"] + "\n      #market1")
		file_data_new = file_data_new.replace("#currency", cfg_json["key"] + ":\n      key: " + cfg_json["code_name"] + "\n      code: " + cfg_json["code_name"] + "\n      name: " + cfg_json["name"] + "\n      format: '0,0.0000'\n    #currency")
		file_data_new = file_data_new.replace("#deposit_channel", cfg_json["key"] + ":\n      key: Block Chain\n      title: " + cfg_json["name"] + " Deposits\n      intro: Deposit " + cfg_json["key"] + " from your own wallet address to GRAVIEX account\n      latency: 1 confirmation\n      transfer: Manual\n      go: Deposit\n    #deposit_channel")
		file_data_new = file_data_new.replace("#private_deposits", cfg_json["key"] + "s:\n        gen_address:\n          require_transaction: it can't generate new address if it hasn't been used.\n      #private_deposits")
		file_data_new = file_data_new.replace("#withdraws_msgs", cfg_json["key"] + "s:\n        destroy:\n          notice: Withdraw been canceled, frozen balance has returned to your account\n        update:\n          notice: Withdraw request is submit successful, we will process it as soon\n            as possible\n          alert_two_factor: Two-Factor Authentication error\n        new:\n          submit: Submit\n          allin: All-In\n          fund_source_label: Label\n          manage_fund_source: Manage Fund Source\n        create:\n          notice: Withdrawal request successfully submitted. Use the info below to\n            complete the bank transfer.\n      #withdraws_msgs")
		file_data_new = file_data_new.replace("#assets", cfg_json["code"] + "-assets: " + cfg_json["code_name"] + " Assets\n        #assets")
		file_data_new = file_data_new.replace("#liab_veriffy", "verify-" + cfg_json["code"] + ": Verify My " + cfg_json["code_name"] + " Assets\n        #liab_veriffy")
		file_data_new = file_data_new.replace("#liab_assest", cfg_json["code"] + "-assets-total: 'Total " + cfg_json["code_name"] + " assets of exchange: '\n        #liab_assest")
		file_data_new = file_data_new.replace("#coin_assests", cfg_json["code"] + "_assets:\n        title: " + cfg_json["code_name"] + " Assets\n        intro: All of exchange's " + cfg_json["code_name"] + " assets are listed here.\n        total: Total " + cfg_json["code_name"] + " Assets\n        address: Address\n      #coin_assests")
		file_data_new = file_data_new.replace("#funds_show1", cfg_json["code"] + "_format: '0.00000000'\n        #funds_show1")
		file_data_new = file_data_new.replace("#funds_show_reason", cfg_json["code"] + ":\n            strike_add: Plus\n            strike_sub: Sub\n            deposit: Deposit\n            withdraw: Withdraw\n            fix: Fix\n          #funds_show_reason")
		file_data_new = file_data_new.replace("#market_list", cfg_json["code"] + "_html: \"<i class='fa fa-check'></i><span>" + cfg_json["code_name"] + " Markets</span>\"\n        #market_list")
		file_data_new = file_data_new.replace("#shared_balances", cfg_json["code"] + "_format: '0.00000000'\n        #shared_balances")
		file_data_new = file_data_new.replace("#withdraw_amount", cfg_json["key"] + ":\n          sum: Minimum amount 0.001\n          fund_extra: Enter a label for this address (optional)\n        #withdraw_amount")
		file_data_new = file_data_new.replace("#withdraw_sum", cfg_json["key"] + ":\n          sum: \"<a target='_balance' href='#'>Fee structure</a>\"\n        #withdraw_sum")
		file_data_new = file_data_new.replace("#withdraw_labels", cfg_json["key"] + ":\n          fee: Fee\n          sum: Amount\n          fund_uid: " + cfg_json["name"] + " Address\n          fund_extra: Label\n          account_balance: Account Balance\n          member_name: Account\n        #withdraw_labels")
		file_data_new = file_data_new.replace("#admin_deposits", cfg_json["key"] + "s:\n        update:\n          notice: The deposit was successful.\n        index:\n          accept: Accept\n          accept_confirm: Confirm deposit?\n      #admin_deposits")
		file_data_new = file_data_new.replace("#admin_widraws", cfg_json["key"] + "s:\n        index:\n          one: Pending withdrawals\n          all: Last 72 hours\n          empty: No data\n        show:\n          process: Accepted\n          succeed: Withdraw\n          reject: Reject\n          succeed_confirm: Process withdrawal?\n          reject_confirm: Reject withdrawal?\n          withdraw: Withdrawals\n      #admin_widraws")
		file_data_new = file_data_new.replace("#deposit_coin", "deposits/" + cfg_json["key"] + ":\n    aasm_state:\n      submitted: Submitted\n      accepted: Accepted\n      checked: Checked\n      warning: Warning\n  #deposit_coin")
		file_data_new = file_data_new.replace("#easy_table", cfg_json["key"] + ":\n      amount: Amount\n      txid: TxId\n      created_at: Created At\n      confirmations: Confirmations\n      member_name: Member\n      state_and_actions: State/Actions\n      currency_obj_key_text: Currency\n    #easy_table")
		file_data_new = file_data_new.replace("#enum_currence", cfg_json["code"] + ": " + cfg_json["code_name"] + "\n      #enum_currence")
		file_data_new = file_data_new.replace("#fund_source", cfg_json["key"] + ": " + cfg_json["name"] + "\n        #fund_source")
		file_data_new = file_data_new.replace("#withdraw_channel", cfg_json["key"] + ":\n      key: Blockchain\n      title: " + cfg_json["name"] + " Blockchain\n      intro: Withdraw " + cfg_json["name"] + " to your own " + cfg_json["name"] + " wallet\n      latency: 10 minutes\n      transfer: Manual\n      go: Withdraw\n    #withdraw_channel")
		file_data_new = file_data_new.replace("#withdraws_coin", "withdraws/" + cfg_json["key"] + ":\n    aasm_state:\n      submitting: Submitting\n      submitted: Submitted\n      rejected: Rejected\n      accepted: Accepted\n      suspect: Suspect\n      processing: processing\n      done: Done\n      almost_done: Almost Done\n      canceled: Cancelled\n      failed: Failed\n  #withdraws_coin")
		with open(coin_update_path + "/config/locales/server.en.yml", "w") as f:
			f.write(file_data_new)
		file_data = None
		with open(coin_update_path + "/spec/controllers/private/assets_controller_spec.rb", "r") as f:
			file_data = f.read();
		file_data_new = file_data.replace("#it", "it { expect(assigns(:" + cfg_json["code"] + "_account)).to be_nil }\n      #it")
		with open(coin_update_path + "/spec/controllers/private/assets_controller_spec.rb", "w") as f:
			f.write(file_data_new)
		with open(coin_update_path + "/public/templates/funds/deposit.html", "a+") as f:
			f.write("<ng-include ng-if=\"currency == '" + cfg_json["code"] + "'\" src=\"'/templates/funds/deposit_" + cfg_json["code"] + ".html'\"></ng-include>\n")
		with open(coin_update_path + "/public/templates/funds/withdraw.html", "a+") as f:
			f.write("<ng-include ng-if=\"currency == '" + cfg_json["code"] + "'\" src=\"'/templates/funds/withdraw_" + cfg_json["code"] + ".html'\"></ng-include>\n")
		with open(coin_update_path + "/public/templates/funds/deposit_" + cfg_json["code"] + ".html", "w+") as f:
			f.write("<h2 class=\"panel-title\">{{\"funds.deposit_" + cfg_json["code"] + ".title\" | t}}</h2>\n\n")
			f.write("<ng-include src=\"'/templates/funds/_deposit_coin.html'\"></ng-include>\n\n")
			f.write("<ng-include src=\"'/templates/funds/_deposit_coin_history.html'\"></ng-include>\n\n")
		with open(coin_update_path + "/public/templates/funds/withdraw_" + cfg_json["code"] + ".html", "w+") as f:
			f.write("<h2 class=\"panel-title\">{{\"funds.withdraw_" + cfg_json["code"] + ".title\" | t}}</h2>\n")
			f.write("<p class=\"help-block\">\n")
			f.write("  {{\"funds.withdraw_coin.intro\" | t}}\n")
			f.write("</p>\n\n")
                        f.write("<p class=\"help-block\">\n")
                        f.write("  {{\"funds.withdraw_coin.withdraw_limit_" + cfg_json["code"] + "\" | t}}\n")
                        f.write("</p>\n\n")
			f.write("<ng-include src=\"'/templates/funds/_coin_withdraw.html'\"></ng-include>\n")
		with open(coin_update_path + "/spec/fixtures/deposit_channels.yml", "a+") as f:
			f.write("- id: " + str(dep_id) + "\n")
			f.write("  key: " + cfg_json["key"] + "\n")
			f.write("  currency: " + cfg_json["code"] + "\n")
			f.write("  min_confirm: " + cfg_json["min_confirm"] + "\n")
			f.write("  max_confirm: " + cfg_json["max_confirm"] + "\n")
		with open(coin_update_path + "/spec/fixtures/withdraw_channels.yml", "a+") as f:
			f.write("- id: " + str(with_id) + "\n")
			f.write("  key: " + cfg_json["key"] + "\n")
			f.write("  currency: " + cfg_json["code"] + "\n")
			f.write("  fixed: " + cfg_json["withdraw_fixed"] + "\n")
			f.write("  max: " + cfg_json["withdraw_max"] + "\n")
			f.write("  fee: " + cfg_json["withdraw_fee"] + "\n")
			f.write("  inuse: true" + "\n")
			f.write("  type: " + cfg_json["withdraw_type"] + "\n")
		file_data = None
		with open(coin_update_path + "/app/assets/javascripts/funds/models/withdraw.js.coffee", "r") as f:
			file_data = f.read();
		file_data_new = file_data.replace("#currency", "when '" + cfg_json["code"] + "' then '" + cfg_json["key"] + "s'\n      #currency")
		with open(coin_update_path + "/app/assets/javascripts/funds/models/withdraw.js.coffee", "w") as f:
			f.write(file_data_new)
		file_data = None
		with open(coin_update_path + "/app/assets/stylesheets/market.css.scss", "r") as f:
			file_data = f.read();
		file_data_new = file_data.replace("/*markets*/", "&." + cfg_json["code"] + " { tr.quote-" + cfg_json["code"] + " { display: block; } }\n      /*markets*/")
		with open(coin_update_path + "/app/assets/stylesheets/market.css.scss", "w") as f:
			f.write(file_data_new)
                with open(coin_update_path + "/app/assets/javascripts/locales/en.js.erb", "a+") as f:
                        f.write("\n")
		return id;

class Db:
	def CreateQuery(self, cfg_json, folder, currency_id):
		coin_update_path = "./Coins/" + cfg_json["name"] + "/" + folder
		with open(coin_update_path + "/admin_update_accounts.sql", "w+") as f:
			f.write("use graviex_production;\ninsert into accounts(member_id, currency, balance, locked)\n	select id, " + str(currency_id) + ", 0, 0 from members where id=2 or id=3")
                with open(coin_update_path + "/update_accounts.sql", "w+") as f:
                        f.write("use graviex_production;\ninsert into accounts(member_id, currency, balance, locked)\n  select id, " + str(currency_id) + ", 0, 0 from members where id not in (select member_id from accounts where currency=" + str(currency_id) + ")")

if __name__ == '__main__':
	print "start adding coin"
	reload(sys)
	sys.setdefaultencoding('utf-8')
	cfg = Config();
	cfg_json = cfg.Load("add_coin_config.json")
	print cfg_json["name"]

	backup = Backup();
	backup.Process(cfg_json, "Backup")
	backup.Process(cfg_json, "Update")

	update = Update()
	currency_id = update.Process(cfg_json, "Update")

	db = Db()
	db.CreateQuery(cfg_json, "Update", currency_id)
	print "finished successfully"
