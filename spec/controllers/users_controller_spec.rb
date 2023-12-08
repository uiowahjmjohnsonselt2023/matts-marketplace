require 'rails_helper'

describe UsersController, type: :controller do
  describe '#index' do
    it 'assigns @users and renders index template' do
      users = create_list(:user, 3) # Assuming you have FactoryBot set up
      users.each do |user|
        sign_in user
      end
      get :index
      expect(assigns(:users)).to match_array(users)
      expect(response).to render_template('index')
    end
  end

  describe '#show' do
    it "calls new method in User model" do
      expect(User).to receive(:new)
      get :new
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      let(:user_params) do
        ActionController::Parameters.new(
          first_name: 'Haruko',
          last_name: 'Okada',
          email: 'test@g.com',
          username: 'haruko'
        ).permit!
      end
      it 'calls User.new with user_params' do
        expect(User).to receive(:new).with(user_params)
        post :create, params: { user: user_params }
      end
      it 'redirects to the created user' do
        user_params = attributes_for(:user)
        post :create, params: { user: user_params }
        expect(response).to redirect_to(user_url(User.last))
        expect(flash[:notice]).to eq('User was successfully created.')
      end
    end
    context 'with invalid parameters' do
      it 'does not save the new user' do
        invalid_user_params = { email: '', password: 'password' } # Invalid params
        expect {
          post :create, params: { user: invalid_user_params }
        }.to_not change(User, :count)
      end
      it 're-renders the new method' do
        invalid_user_params = { email: '', password: 'password' } # Invalid params
        post :create, params: { user: invalid_user_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#update' do
    before(:each) do
      @user = create(:user)
      sign_in @user
    end
    context 'with valid parameters' do
      it 'successfully updates user' do
        patch :update, params: { id: @user.id, user: { first_name: 'Sergio', last_name: 'Martelo' } }
        @user.reload
        expect(@user.first_name).to eq('Sergio')
        expect(@user.last_name).to eq('Martelo')
      end
      it 'redirects to updated user with correct notice' do
        patch :update, params: { id: @user.id, user: { first_name: 'Sergio', last_name: 'Martelo' } }
        expect(response).to redirect_to(user_url(@user))
        expect(flash[:notice]).to eq('User was successfully updated.')
      end
    end
    context 'with invalid parameters' do
      it 'does not update the user' do
        patch :update, params: { id: @user.id, user: { email: '' } }
        @user.reload
        expect(@user.email).not_to eq('')
      end
      it 'renders the edit template' do
        patch :update, params: { id: @user.id, user: { email: '' } }
        expect(response).to render_template(:edit)
      end
      it 'responds with JSON status: :unprocessable_entity' do
        patch :update, params: { id: @user.id, user: { email: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['email']).to include("can't be blank")
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      @user = create(:user)
      sign_in @user
    end
    it 'destroys the user' do
      expect {
        delete :destroy, params: { id: @user.id }
      }.to change(User, :count).by(-1)
    end
    it 'redirects to users_url with a success notice' do
      delete :destroy, params: { id: @user.id }
      expect(response).to redirect_to(users_url)
      expect(flash[:notice]).to eq('User was successfully destroyed.')
    end
  end
end