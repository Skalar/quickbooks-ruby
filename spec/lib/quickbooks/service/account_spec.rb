describe Quickbooks::Service::Account do
  before(:all) do
    construct_service :account
  end

  it "can query for accounts" do
    xml = fixture("accounts.xml")
    stub_request(:get, @service.url_for_query, ["200", "OK"], xml, true)

    accounts = @service.query
    accounts.entries.count.should == 10

    sales = accounts.entries.first
    sales.name.should == 'Cost of Goods Sold'
  end

  it "can fetch an account by ID" do
    xml = fixture("fetch_account_by_id.xml")
    model = Quickbooks::Model::Account
    stub_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)
    account = @service.fetch_by_id(1)

    account.name.should == "Sales of Product Income"
    account.classification.should == Quickbooks::Model::Account::REVENUE
    account.tax_account?.should == false
    account.currency_ref.should == 'USD'
  end
end
