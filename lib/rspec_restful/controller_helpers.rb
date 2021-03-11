module RspecRestful
  module ControllerHelpers
    def describe_restful_index_action
      describe 'GET :index' do
        before do
          get :index
        end

        it 'renders the :index template with 200 status' do
          expect(response).to be_success
          expect(response).to render_template('index')
        end
      end
    end

    def describe_restful_show_action(resource)
      describe 'on GET to :show' do
        let(:item) { create(resource) }

        before do
          get :show, params: { id: item.id }
        end

        it 'renders the :show template with 200 status' do
          expect(response).to be_success
          expect(response).to render_template('show')
        end
      end
    end

    def describe_restful_new_action
      describe 'on GET to :new' do
        before do
          get :new
        end

        it 'renders the :new template with 200 status' do
          expect(response).to be_success
          expect(response).to render_template('new')
        end
      end
    end

    # Expects a method called test_{class_name}_params to be defined in the
    # current spec group. This should return a hash with the params you want
    # passed to the action.
    def describe_restful_create_action(klass, options = {})
      name = klass.name.underscore
      url_method = options[:url_method] || (name.pluralize + '_url').to_sym
      params_method = ('test_' + name + '_params').to_sym
      name = name.to_sym

      describe 'POST :create' do
        context 'with valid data' do
          before do
            stub_as_always_valid(klass)
            post :create, params: { name => send(params_method) }
          end

          it "redirects to #{url_method}" do
            expect(response).to be_redirect
            expect(response).to redirect_to(send(url_method))
          end

          it "creates a #{klass.name}" do
            expect do
              post :create, params: { name => send(params_method) }
            end.to change(klass, :count).by(1)
          end
        end

        context 'with invalid data' do
          before do
            stub_as_never_valid(klass)
            post :create, params: { name => send(params_method) }
          end

          it 'renders the :new template with 200 status' do
            expect(response).to be_success
            expect(response).to render_template(:new)
          end

          it "doesn't create a #{klass.name}" do
            expect do
              post :create, params: { name => send(params_method) }
            end.not_to change(klass, :count)
          end
        end
      end
    end

    def describe_restful_edit_action(resource, options = {})
      describe 'GET :edit' do
        if options[:object_method].present?
          let(:item) { self.send(options[:object_method]) }
        else
          let(:item) { create(resource) }
        end

        before do
          get :edit, params: { id: item.id }
        end

        it 'renders the :edit template with 200 status' do
          expect(response).to be_success
          expect(response).to render_template('edit')
        end
      end
    end

    def describe_restful_update_action(klass, options = {})
      name = klass.name.underscore
      url_method = options[:url_method] || (name.pluralize + '_url').to_sym
      params_method = ('test_' + name + '_params').to_sym
      name = name.to_sym

      describe 'on PUT to :update' do
        if options[:object_method].present?
          before { @item = self.send(options[:object_method]) }
        else
          before { @item = create(name) }
        end

        context 'with valid data' do
          before do
            stub_as_always_valid(klass)
            put :update, params: { id: @item.id, name => send(params_method) }
          end

          it "redirects to #{url_method}" do
            expect(response).to be_redirect
            expect(response).to redirect_to(send(url_method))
          end
        end

        context 'with invalid data' do
          before do
            stub_as_never_valid(klass)
            put :update, params: { id: @item.id, name => send(params_method) }
          end

          it 'renders the :edit template with 200 status' do
            expect(response).to be_success
            expect(response).to render_template('edit')
          end
        end
      end
    end

    def describe_restful_destroy_action(klass, options = {})
      name = klass.name.underscore
      url_method = options[:url_method] || (name.pluralize + '_url').to_sym
      name = name.to_sym

      describe 'on DELETE to :destroy' do
        if options[:object_method].present?
          before { @item = self.send(options[:object_method]) }
        else
          before { @item = create(name) }
        end

        it "redirects to #{url_method}" do
          delete :destroy, params: { id: @item.id }
          expect(response).to be_redirect
          expect(response).to redirect_to(send(url_method))
        end

        it "destroys a #{klass.name}" do
          expect do
            delete :destroy, params: { id: @item.id }
          end.to change(klass, :count).by(-1)
        end
      end
    end
  end
end
