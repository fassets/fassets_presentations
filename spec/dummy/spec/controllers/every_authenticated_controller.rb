shared_examples_for "every authenticated controller" do
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end
  before(:each) do
    # mock up an authentication in the underlying warden library
    request.env['warden'] = mock(Warden, :authenticate => mock_user,
                                 :authenticate! => mock_user)
  end
end
