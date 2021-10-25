require 'selenium-webdriver'
require 'webdrivers'
require 'rspec'

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

$wait = Selenium::WebDriver::Wait.new(timeout: 5)

def alerting(driver, i)
    driver.find_element(id: "coin_#{i}").click
    yay = driver.switch_to.alert.text
    puts yay
    yay
end

def less_than(driver, weight, i)
    driver.find_element(id: 'weigh').click
    $wait.until { driver.find_element(xpath: "//div[1]/div[1]/div[5]/ol[1]/li[#{weight}]").displayed? }
    right_result = driver.find_element(xpath: "//div[1]/div[1]/div[5]/ol[1]/li[#{weight}]").text
    puts right_result
    if right_result.include?('<')
        true
    end
end

def find_fake(driver)
    weight = 1
    $wait.until { driver.find_element(xpath: "//div[1]/div[1]/div[5]/ol[1]/li[#{weight}]").displayed? }
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
            if less_than(driver, weight, i) == true
                return alerting(driver, i)
            end
        end
    else
        sleep 2
        i = 1
        for i in 4..7
            weight +=1 
            reset.click
            driver.find_element(id: 'left_0').send_keys("#{i}")
            driver.find_element(id: 'right_0').send_keys('3')
            if less_than(driver, weight, i) == true
                return alerting(driver, i)
            end
        end
    end
end

describe "finding fake gold bar" do
    it "runs Selenium automation" do
    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to "http://ec2-54-208-152-154.compute-1.amazonaws.com/"
    init_comparison(driver)
    final = find_fake(driver)
    expect(final).to eq("Yay! You find it!")
    driver.quit
    end
end