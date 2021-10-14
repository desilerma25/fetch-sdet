require 'selenium-webdriver'
require 'webdrivers'
require 'rspec'


# driver = Selenium::WebDriver.for :chrome



# driver.navigate.to "http://ec2-54-208-152-154.compute-1.amazonaws.com/"

def init_comparison(driver)
    driver.find_element(id: 'left_0').send_keys('0')
    driver.find_element(id: 'left_1').send_keys('1')
    driver.find_element(id: 'left_2').send_keys('2')
    driver.find_element(id: 'left_3').send_keys('3')

    driver.find_element(id: 'right_0').send_keys('4')
    driver.find_element(id: 'right_1').send_keys('5')
    driver.find_element(id: 'right_2').send_keys('6')
    driver.find_element(id: 'right_3').send_keys('7')

    driver.find_element(id: 'weigh').click
end

# wait = Selenium::WebDriver::Wait.new(timeout: 5)

# weight = 1

def find_fake(driver)
    wait = Selenium::WebDriver::Wait.new(timeout: 5)
    weight = 1
    wait.until { driver.find_element(xpath: "//div[1]/div[1]/div[5]/ol[1]/li[#{weight}]").displayed? }
    result = driver.find_element(xpath: "//div[1]/div[1]/div[5]/ol[1]/li[#{weight}]").text
    puts result
    reset = driver.find_element(xpath: '//div[1]/div[1]/div[4]/button[1]')

    if driver.find_element(xpath: "//div[1]/div[1]/div[5]/ol[1]/li[#{weight}]").text.include?('=')
        driver.find_element(id: 'coin_8').click
        yay = driver.switch_to.alert.text
        puts yay
        return yay
        driver.quit

    elsif driver.find_element(xpath: "//div[1]/div[1]/div[5]/ol[1]/li[#{weight}]").text.include?('<')
        sleep 2
        i = 1
        for i in 0..3
            weight +=1 
            reset.click
            driver.find_element(id: 'left_0').send_keys("#{i}")
            driver.find_element(id: 'right_0').send_keys('4')
            driver.find_element(id: 'weigh').click
            # weight +=1 
            wait.until { driver.find_element(xpath: "//div[1]/div[1]/div[5]/ol[1]/li[#{weight}]").displayed? }
            left_result = driver.find_element(xpath: "//div[1]/div[1]/div[5]/ol[1]/li[#{weight}]").text
            puts left_result
            if left_result.include?('<')
                # need to work on choosing goldbar
            driver.find_element(id: "coin_#{i}").click
            yay = driver.switch_to.alert.text
            puts yay
            return yay
            driver.quit
            break
            end
            i +=1
        end
    else
        sleep 2
        i = 1
        for i in 4..7
            weight +=1 
            reset.click
            driver.find_element(id: 'left_0').send_keys("#{i}")
            driver.find_element(id: 'right_0').send_keys('3')
            driver.find_element(id: 'weigh').click
            wait.until { driver.find_element(xpath: "//div[1]/div[1]/div[5]/ol[1]/li[#{weight}]").displayed? }
            right_result = driver.find_element(xpath: "//div[1]/div[1]/div[5]/ol[1]/li[#{weight}]").text
            puts right_result
            if right_result.include?('<')
                driver.find_element(id: "coin_#{i}").click
                yay = driver.switch_to.alert.text
                puts yay
                return yay
                driver.quit
                break
            end
            i +=1
        end
    end
end

# def yay_alert(driver)
#     wait = Selenium::WebDriver::Wait.new(timeout: 10)
#     wait.until { driver.find_element(class: 'alert').displayed? }
#     banner = driver.find_element(class: 'alert')
#     banner_text = banner.text
# end

describe "finding fake gold bar" do
    # before(:each) do
    #     driver = Selenium::WebDriver.for :chrome
    #     driver.navigate.to "http://ec2-54-208-152-154.compute-1.amazonaws.com/"
    # end
    it "runs Selenium automation" do
    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to "http://ec2-54-208-152-154.compute-1.amazonaws.com/"
    init_comparison(driver)
    final = find_fake(driver)
    expect(final).to eq("Yay! You find it!")
    driver.quit
    end
end