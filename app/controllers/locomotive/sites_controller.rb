module Locomotive
  class SitesController < BaseController

    respond_to :json, only: [:create, :destroy]

    def index
      authorize Site
      @sites = service.list
      respond_with @sites, layout: '/locomotive/layouts/without_sidebar'
    end

    def new
      authorize Site
      @site = Site.new
      respond_with @site
    end

    def create
      authorize Site
      @site = service.create(site_params)
      respond_with @site, location: edit_my_account_path
    end

    def destroy
      @site = self.current_locomotive_account.sites.find(params[:id])
      authorize @site

      if @site != current_site
        @site.destroy
      else
        @site.errors.add(:base, 'Can not destroy the site you are logging in now')
      end

      respond_with @site, location: edit_my_account_path
    end

    private

    def service
      @service ||= Locomotive::SiteService.new(self.current_locomotive_account)
    end

    def site_params
      params.require(:site).permit(:name, :subdomain)
    end

  end
end
