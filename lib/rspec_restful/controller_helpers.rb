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

    def describe_restful_show_action(klass, options = {})
      factory_name = extract_factory_name(klass, options)

      describe 'on GET to :show' do
        let(:item) { create(factory_name) }

        before do
          get :show, id: item.id
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
      factory_name = extract_factory_name(klass, options)
      url_method = url_method_for_klass(klass, options)
      params_method = params_method_for_klass(klass)
      klass_name_symbol = symbolized_klass_name(klass)

      describe 'POST :create' do
        context 'with valid data' do
          before do
            stub_as_always_valid(klass)
            post :create, klass_name_symbol => send(params_method)
          end

          it "redirects to #{url_method}" do
            expect(response).to be_redirect
            expect(response).to redirect_to(send(url_method))
          end

          it "creates a #{klass.name}" do
            expect do
              post :create, klass_name_symbol => send(params_method)
            end.to change(klass, :count).by(1)
          end
        end

        context 'with invalid data' do
          before do
            stub_as_never_valid(klass)
            post :create, klass_name_symbol => send(params_method)
          end

          it 'renders the :new template with 200 status' do
            expect(response).to be_success
            expect(response).to render_template(:new)
          end

          it "doesn't create a #{klass.name}" do
            expect do
              post :create, klass_name_symbol => send(params_method)
            end.not_to change(klass, :count)
          end
        end
      end
    end

    def describe_restful_edit_action(klass, options = {})
      factory_name = extract_factory_name(klass, options)

      describe 'GET :edit' do
        let(:item) { create(factory_name) }

        before do
          get :edit, id: item.id
        end

        it 'renders the :edit template with 200 status' do
          expect(response).to be_success
          expect(response).to render_template('edit')
        end
      end
    end

    def describe_restful_update_action(klass, options = {})
      factory_name = extract_factory_name(klass, options)
      url_method = url_method_for_klass(klass, options)
      params_method = params_method_for_klass(klass)
      klass_name_symbol = symbolized_klass_name(klass)

      describe 'on PUT to :update' do
        before do
          @item = create(factory_name)
        end

        context 'with valid data' do
          before do
            stub_as_always_valid(klass)
            put :update, id: @item.id, klass_name_symbol => send(params_method)
          end

          it "redirects to #{url_method}" do
            expect(response).to be_redirect
            expect(response).to redirect_to(send(url_method))
          end
        end

        context 'with invalid data' do
          before do
            stub_as_never_valid(klass)
            put :update, id: @item.id, klass_name_symbol => send(params_method)
          end

          it 'renders the :edit template with 200 status' do
            expect(response).to be_success
            expect(response).to render_template('edit')
          end
        end
      end
    end

    def describe_restful_destroy_action(klass, options = {})
      factory_name = extract_factory_name(klass, options)
      url_method = url_method_for_klass(klass, options)

      describe 'on DELETE to :destroy' do
        before do
          @item = create(factory_name)
        end

        it "redirects to #{url_method}" do
          delete :destroy, id: @item.id
          expect(response).to be_redirect
          expect(response).to redirect_to(send(url_method))
        end

        it "destroys a #{klass.name}" do
          expect do
            delete :destroy, id: @item.id
          end.to change(klass, :count).by(-1)
        end
      end
    end

    private

    def extract_factory_name(klass, options)
      options[:object_method].presence || symbolized_klass_name(klass)
    end

    def url_method_for_klass(klass, options)
      options[:url_method] || (underscored_klass_name(klass).pluralize + '_url').to_sym
    end

    def params_method_for_klass(klass)
      ('test_' + underscored_klass_name(klass) + '_params').to_sym
    end

    def symbolized_klass_name(klass)
      underscored_klass_name(klass).to_sym
    end

    def underscored_klass_name(klass)
      klass.name.underscore
    end
  end
end
