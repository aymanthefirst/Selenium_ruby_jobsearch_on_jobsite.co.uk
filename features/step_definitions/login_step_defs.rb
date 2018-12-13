Given("I access the home page") do
    login_service.visit_homepage
    login_service.sign_in
    # login_service.make_search_query
end

Then("I apply for many jobs") do
    login_service.automate
  end
  
  