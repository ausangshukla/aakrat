FactoryBot.define do
  factory :daily_activity do
    user { nil }
    project { nil }
    step { nil }
    details { "MyText" }
    status { "MyString" }
    cost { "9.99" }
  end

  factory :quote do
    company { nil }
    user { nil }
    client { nil }
    project_type { "MyString" }
    scale { "MyString" }
    style { "MyString" }
    pattern { "MyString" }
    services { "MyText" }
  end

  factory :attachment do
    name { "MyString" }
    attached_by { nil }
    approval_status { "MyString" }
    approved_by { nil }
    company { nil }
    project { nil }
    phase { nil }
    step { nil }
  end

  factory :site_visit do
    company { Company.all.sample }
    project { company.projects.sample }
    phase { project.phases.sample }
    cost_cents { (rand(2) + 1) * 1000_00 }
    scheduled_on { Date.today + rand(10).days }
    conducted_on {  }
    assigned_to { company.users.sample }
    completed { rand(2) }
  end

  factory :project_access do
    company { nil }
    user { nil }
    project { nil }
    role_name { "MyString" }
  end


  factory :client do
    if User.clients.count > 0
    user { User.clients.sample  }
      first_name { user.first_name }
      last_name { user.last_name }
      email { user.email }
      phone { user.phone }
    else
      first_name { Faker::Name.first_name }
      last_name  { Faker::Name.last_name }
      email { company ? "#{first_name.downcase}@#{company.name.parameterize}.com" : Faker::Internet.email }
      phone { Faker::PhoneNumber.cell_phone }      
    end
    user_type { Client::TYPES[rand(Client::TYPES.length)]}
    company { nil }
  end

  factory :step do
    name { Faker::Company.catch_phrase }
    start_date { Time.zone.today - rand(10).days }
    days { rand(10) + rand(5)  + 4}
    status {  }
    project { Project.all.sample }
    phase { project.phases.sample }
    assigned_to { project.company.users.sample }
    visible_to_client { rand(2) }
    completed { rand(2) }
    details { Faker::Quotes::Rajnikanth.joke }
  end

  factory :note do
    details { Faker::Quotes::Rajnikanth.joke }
  end

  factory :phase do
    name { Faker::Company.catch_phrase }
    start_date { Time.zone.today - rand(10).days }
    days { rand(10) + rand(5)  + 4}
    status { Phase::STATUS[rand(Phase::STATUS.length)] }
    project { Project.all.sample }
    assigned_to { project.company.users.sample }
    visible_to_client { rand(2) }
    payment_required { rand(2) }
    payment_status {  }
    payment_due_percentage { payment_required ? rand(10) : 0 }
    percentage_complete { rand(100) }
    completed { rand(2) }
    details { Faker::Quotes::Rajnikanth.joke }
  end

  factory :project do
    name { ["Villa Project", "Industrial Shed", "Interior Design", "Farm House", "Vacation Home", "Low cost housing"][rand(6)] }
    start_date { Time.zone.today - rand(10).days }
    end_date { Time.zone.today + rand(10).days + rand(24).months }
    client_estimated_budget { (rand(100) + rand(100) ) * 100_000 }
    estimated_builtup_area { (rand(5) + 1)*1000 }
    actual_builtup_area { estimated_builtup_area }
    percentage_of_estimated_budget { (rand(2) + 1)*10 }
    percentage_completed { rand(100) }
    status { Project::STATUS[rand(Project::STATUS.length)] }
    company { Company.all.sample }
    client { User.clients.sample }
    team_lead { User.team_leads.sample }
    currency { company.currency }
    details { Faker::Quotes::Rajnikanth.joke }
    address { Faker::Address.full_address }
  end

  factory :payment do
    company { Company.all.sample }
    amount_cents { rand(100)*100 + rand(100) * 100000 }
    project { company.projects.sample }
    phase { project.phases.sample }
    status { Payment::STATUS[rand(Payment::STATUS.length)] }
    due_date { phase.end_date + rand(10).days }
    received_on { due_date + rand(10).days - rand(10).days }
    discount { 0 }
    reference_number { (0...8).map { (65 + rand(26)).chr }.join }
    user { company.users.sample }
  end


  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email { company ? "#{first_name.downcase}@#{company.name.parameterize}.com" : Faker::Internet.email }
    password { "password" }
    phone { Faker::PhoneNumber.cell_phone }
    confirmed_at { Time.zone.now }
    accept_terms {true}
  end

  factory :company do
    name { Faker::Company.name }
    category { Faker::Company.industry }
    url { "https://#{Faker::Internet.domain_name}" }
    company_type { Company::TYPES[rand(Company::TYPES.length)] }
    currency {"INR"}
  end
end
