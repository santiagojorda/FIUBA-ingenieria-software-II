Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure

DB =
  case Padrino.env
  when :development
    dev_db_url = ENV['DEV_DB_URL'] || 'postgres://jobvacancy:jobvacancy@localhost/jobvacancy_development'
    Sequel.connect(dev_db_url, loggers: [logger])
  when :test
    test_db_url = ENV['TEST_DB_URL'] || 'postgres://jobvacancy:jobvacancy@localhost/jobvacancy_test'
    Sequel.connect(test_db_url, loggers: [logger])
  when :production
    Sequel.connect(ENV['DATABASE_URL'], loggers: [logger])
  end

# this makes sequel to use debug method to log
DB.sql_log_level = :debug
