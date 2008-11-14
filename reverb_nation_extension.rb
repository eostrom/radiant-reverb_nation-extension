# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ReverbNationExtension < Radiant::Extension
  version "1.0"
  description "Integrates concert listings from ReverbNation.com."
  url "http://tincatland.com/"
  
  # define_routes do |map|
  #   map.connect 'admin/reverb_nation/:action', :controller => 'admin/reverb_nation'
  # end
  
  def activate
    # admin.tabs.add "Reverb Nation", "/admin/reverb_nation", :after => "Layouts", :visibility => [:all]
    Page.send :include, ReverbNationTags
  end
  
  def deactivate
    # admin.tabs.remove "Reverb Nation"
  end
  
end
