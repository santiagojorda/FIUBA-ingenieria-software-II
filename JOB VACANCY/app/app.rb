module JobVacancy
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    Padrino.configure :development, :test do
      set :delivery_method, file: {
        location: "#{Padrino.root}/tmp/emails"
      }
    end

    Padrino.configure :production do
      set :delivery_method, smtp: {
        address: ENV['SMTP_ADDRESS'],
        port: ENV['SMTP_PORT'],
        user_name: ENV['SMTP_USER'],
        password: ENV['SMTP_PASS'],
        authentication: :plain,
        enable_starttls_auto: true
      }
    end
  end
end
