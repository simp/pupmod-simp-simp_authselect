Puppet::Functions.create_function(:'create_authselect_content') do
  def create_authselect_content(pam_authsections)
    contents = {}
    pam_authsections.each  do |auth_section| 
      contents[auth_section] = {
        :content => "include simp/#{auth_section}-auth"
      }
    end
    $contents
  end
end
      

