class DemoQALogin
    include Capybara::DSL
    HOMEPAGE_URL = 'https://www.jobsite.co.uk/cgi-bin/login_applicant.cgi?src=qlSignIn'
    USERNAME = "aymanharake@gmail.com"
    PASSWORD = "pascrt12"
    JOB_ROLE = "Junior software developer"
    LOCATION = "london"

    def visit_homepage
      windows.first.maximize
      visit(HOMEPAGE_URL)
    end

    def sign_in
      fill_in("email", with: USERNAME)
      fill_in("password", with: PASSWORD)
      click_on("Log in")
    end

    def make_search_query
      find("#searchBtn").click
      all("input").first.send_keys(JOB_ROLE)
      all("input")[1].send_keys(LOCATION)
      select("10 miles", :from => "Radius")
      find("#search-submit-button-desktop").click
    end

    def automate
      appliedInt = 0
      row = -1
      applicationNumber = 0
      page = 1
      heading = find(".page-title").text
      clickNextPageInt = page - 1
      clickNextPageInt.times do 
        find(".next").click
      end
      1000.times do
        row += 1
        applicationNumber += 1
        applied = false
        rowDiv = all(".job")[row]
        while rowDiv.text.downcase.include?("applied") && row < all(".job-title").size - 1
          row += 1
          rowDiv = all(".job")[row]
        end


        puts "------------------------------------"
        puts current_url
        puts "#{rowDiv.find(".job-title").find("a").text}"
          puts "Applied for #{appliedInt} out of #{applicationNumber} jobs. Page: #{page}, row: #{row}"
        rowDiv.find(".job-title").find("a").click

        if(find("body").text.downcase.include?("sparta")) ||
          (find("body").text.downcase.include?("testing circle"))
            go_back_to_search_page(heading) 
            puts "skipped sparta"
          end

        if find("body").text.downcase.include?("one-click apply")
          begin
            click_on("One-click apply")
          rescue => e
            all(".btn")[5].click
          end
          applied  = true
        end

        

        if find("body").text.downcase.include?("1.Enter your email address".downcase)
          find("#btnSubmit").click
          applied = true
        end

        if (windows.size > 1) 
          windows.last.close
         end

        go_back_to_search_page(heading) 

        if applied == true
          appliedInt += 1
          puts "applied"
        end
        
        if row > all(".job-title").size - 2
          find(".next").click
          row = 0
          page += 1
        end
      end
    end

  def go_back_to_search_page(value)
    while !find("body").text.include?(value)
      page.evaluate_script('window.history.back()')
    end
  end

end
