# module ExternalApiAdaptable
# this module is intended to adapt easily Ekylibre
# to external APIs just by telling the controller
# how to translate API input/output to its Ekylibre equivalent
# this controller actions builder assumes that the controller's name
# is the API output name.

module ExternalApiAdaptable
  extend ActiveSupport::Concern

  module ClassMethods
    def manage_restfully(defaults = {})
      options = defaults.extract! :only, :except
      actions  = [:index, :show, :new, :create, :edit, :update, :destroy]
      actions &= [options[:only]].flatten   if options[:only]
      actions -= [options[:except]].flatten if options[:except]

      name = self.controller_name
      model = defaults[:model].present? ? defaults[:model].to_s.singularize.classify.constantize : name.to_s.singularize.classify.constantize rescue []
      model = model.send defaults[:scope] if defaults[:scope].present?

      search_filters = defaults[:search_filters] || :id

      api_path = self.controller_path.split('/')[0..-2].join('/')

      output_name = name
      locals = {}
      locals[:output_name] = output_name
      locals[:partial_path] = defaults[:partial_path] || "#{output_name.pluralize}/#{output_name.singularize}"
      index = lambda do
        @records = model.all rescue []
        render template: "layouts/#{api_path}/index", locals: locals
      end

      show = lambda do
        @record = model.find(params[:id]) rescue nil
        render partial: "#{api_path}/#{locals[:partial_path]}", locals:{name.singularize.to_sym => @record}
      end

      update = lambda do
        @record = model.find(params[:id])
        render :json, @record.update(permitted_params)
      end

      method_for =
        {
          index:  index,
          show:   show,
          update: update
        }

      actions.each do |action|
        define_method action, method_for[action]
      end

      define_method :permitted_params do
        params.permit!
      end
      private :permitted_params
    end
  end
end