module Angular
  class Waiter
    attr_accessor :page

    def initialize(page)
      @page = page
    end

    def wait_until_ready
      return unless angular_app?

      setup_ready

      start = Time.now
      until ready?
        timeout! if timeout?(start)
        setup_ready if page_reloaded_on_wait?
        sleep(0.01)
      end
    end

    private

    def timeout?(start)
      Time.now - start > Capybara.default_wait_time
    end

    def timeout!
      raise TimeoutError.new("timeout while waiting for angular")
    end

    def ready?
      page.evaluate_script("window.angularReady")
    end

    def angular_app?
      begin
        js = "(typeof angular !== 'undefined') && "
        js += "angular.element(document.querySelector('[ng-app]')).length > 0"
        page.evaluate_script js
      rescue Capybara::NotSupportedByDriverError
        false
      end
    end

    def setup_ready
      page.execute_script <<-JS
        window.angularReady = false;
        var app = angular.element(document.querySelector('[ng-app]'));
        var injector = app.injector();

        injector.invoke(function($browser) {
          $browser.notifyWhenNoOutstandingRequests(function() {
            window.angularReady = true;
          });
        });
      JS
    end

    def page_reloaded_on_wait?
      page.evaluate_script("window.angularReady === undefined")
    end
  end
end

module WaitForAngular
  def wait_for_angular
    Angular::Waiter.new(Capybara.current_session).wait_until_ready
  end
end

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      active = page.evaluate_script('jQuery.active')
      until active == 0
        active = page.evaluate_script('jQuery.active')
      end
    end
  end
end

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature
  config.include WaitForAngular, type: :feature
end
