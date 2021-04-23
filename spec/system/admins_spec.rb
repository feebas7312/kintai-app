require 'rails_helper'

RSpec.describe "責任者の新規登録", type: :system do
  before do
    @admin = FactoryBot.build(:admin)
    @company = FactoryBot.build(:company)
  end

  context '責任者の新規登録ができるとき' do
    it '責任者と会社の正しい情報を入力すれば新規登録ができてトップページに移動する' do
      # トップページにアクセスするとログインページに遷移する
      visit root_path
      # 新規登録ページへのリンクがあることを確認する
      expect(page).to have_link 'アカウント新規作成', href: new_admin_registration_path
      # 新規登録ページへ遷移する
      visit new_admin_registration_path
      # 責任者情報を入力する
      fill_in '社員番号', with: @admin.number
      fill_in '姓', with: @admin.last_name
      fill_in '名', with: @admin.first_name
      find('select[name="admin[birth_date(1i)]"]').find("option[value='1987']").select_option
      find('select[name="admin[birth_date(2i)]"]').find("option[value='3']").select_option
      find('select[name="admin[birth_date(3i)]"]').find("option[value='12']").select_option
      fill_in '電話番号', with: @admin.phone_number
      fill_in 'メールアドレス', with: @admin.email
      fill_in 'admin[password]', with: @admin.password
      fill_in 'パスワード確認', with: @admin.password
      fill_in '入社日', with: @admin.joining_date
      find('select[name="admin[employment_status_id]"]').find("option[value='1']").select_option
      find('select[name="admin[salary_system_id]"]').find("option[value='1']").select_option
      fill_in '給与', with: @admin.wages
      # 次へのボタンを押すと会社情報の入力画面に移動したことを確認する
      find('input[name="commit"]').click
      expect(page).to have_content('会社情報を登録する')
      # 会社情報を入力する
      fill_in '会社名', with: @company.name
      fill_in '郵便番号', with: @company.postal_code
      fill_in '所在地', with: @company.address
      fill_in '電話番号', with: @company.phone_number
      find('select[name="company[cutoff_date_id]"]').find("option[value='4']").select_option
      fill_in '開店時間', with: @company.opening_time
      fill_in '閉店時間', with: @company.closing_time
      # 新規登録ボタンを押すとAdminモデルとCompanyモデルのカウントが上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Admin.count && Company.count }.by(1)
      # トップページに移動したことを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.user-menu').find('span').hover
      ).to have_content('ログアウト')
    end
  end

  context '責任者の新規登録ができないとき' do
    it '誤った責任者情報では新規登録ができずに新規登録ページに戻ってくる' do
      # 新規登録ページへ遷移する
      visit new_admin_registration_path
      # 責任者情報を入力する
      fill_in '社員番号', with: ''
      fill_in '姓', with: ''
      fill_in '名', with: ''
      find('select[name="admin[birth_date(1i)]"]').find("option[value='']").select_option
      find('select[name="admin[birth_date(2i)]"]').find("option[value='']").select_option
      find('select[name="admin[birth_date(3i)]"]').find("option[value='']").select_option
      fill_in '電話番号', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'admin[password]', with: ''
      fill_in 'パスワード確認', with: ''
      fill_in '入社日', with: ''
      find('select[name="admin[employment_status_id]"]').find("option[value='']").select_option
      find('select[name="admin[salary_system_id]"]').find("option[value='']").select_option
      fill_in '給与', with: ''
      # 次へのボタンを押すと責任者の新規登録ページに戻ることを確認する
      find('input[name="commit"]').click
      expect(current_path).to eq(admin_registration_path)
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('エラーが発生')
    end
    it '誤った会社情報では新規登録ができずに新規登録ページに戻ってくる' do
      # 新規登録ページへ遷移する
      visit new_admin_registration_path
      # 正しい責任者情報を入力する
      fill_in '社員番号', with: @admin.number
      fill_in '姓', with: @admin.last_name
      fill_in '名', with: @admin.first_name
      find('select[name="admin[birth_date(1i)]"]').find("option[value='1987']").select_option
      find('select[name="admin[birth_date(2i)]"]').find("option[value='3']").select_option
      find('select[name="admin[birth_date(3i)]"]').find("option[value='12']").select_option
      fill_in '電話番号', with: @admin.phone_number
      fill_in 'メールアドレス', with: @admin.email
      fill_in 'admin[password]', with: @admin.password
      fill_in 'パスワード確認', with: @admin.password
      fill_in '入社日', with: @admin.joining_date
      find('select[name="admin[employment_status_id]"]').find("option[value='1']").select_option
      find('select[name="admin[salary_system_id]"]').find("option[value='1']").select_option
      fill_in '給与', with: @admin.wages
      # 次へのボタンを押すと会社情報の入力画面に移動したことを確認する
      find('input[name="commit"]').click
      expect(page).to have_content('会社情報を登録する')
      # 会社情報を入力する
      fill_in '会社名', with: ''
      fill_in '郵便番号', with: ''
      fill_in '所在地', with: ''
      fill_in '電話番号', with: ''
      find('select[name="company[cutoff_date_id]"]').find("option[value='']").select_option
      fill_in '開店時間', with: ''
      fill_in '閉店時間', with: ''
      # 新規登録ボタンを押してもAdminモデルとCompanyモデルのカウントが上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Admin.count && Company.count }.by(0)
      # 会社情報の新規登録ページに戻ることを確認する
      expect(page).to have_content('会社情報を登録する')
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('エラーが発生')
    end
  end
end

RSpec.describe "ログイン", type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
  end

  context 'ログインできるとき' do
    it '保存されている責任者の情報と合致すればログインができる' do
      # トップページにアクセスするとログインページに遷移する
      visit root_path
      # 正しい責任者情報を入力する
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせるとログアウトボタンが表示されることを確認する
      expect(
        find('.user-menu').find('span').hover
      ).to have_content('ログアウト')
    end
  end

  context 'ログインできないとき' do
    it '保存されている責任者の情報と合致しないとログインができない' do
      # トップページにアクセスするとログインページに遷移する
      visit root_path
      # 責任者情報を入力する
      fill_in '社員番号', with: ''
      fill_in 'パスワード', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページに戻ることを確認する
      expect(current_path).to eq(new_admin_session_path)
    end
  end
end

RSpec.describe "責任者情報の編集", type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
    @edit_admin = FactoryBot.build(:admin)
  end

  context '責任者情報が編集できるとき' do
    it 'ログインしている責任者は自分の登録情報を編集できる' do
      # トップページにアクセスするとログインページに遷移する
      visit root_path
      # 正しい責任者情報を入力する
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせると編集ボタンが表示されることを確認する
      expect(
        find('.user-menu').find('span').hover
      ).to have_content('編集')
      # 編集ページに移動する
      visit edit_admin_registration_path
      # 既に登録済みの内容がフォームに入っていることを確認する
      expect(
        find('input[name="admin[number]"]').value
      ).to eq(@admin.number)
      expect(
        find('input[name="admin[last_name]"]').value
      ).to eq(@admin.last_name)
      expect(
        find('input[name="admin[first_name]"]').value
      ).to eq(@admin.first_name)
      expect(
        find('select[name="admin[birth_date(1i)]"]').value
      ).to eq("#{@admin.birth_date.year}")
      expect(
        find('select[name="admin[birth_date(2i)]"]').value
      ).to eq("#{@admin.birth_date.month}")
      expect(
        find('select[name="admin[birth_date(3i)]"]').value
      ).to eq("#{@admin.birth_date.day}")
      expect(
        find('input[name="admin[phone_number]"]').value
      ).to eq(@admin.phone_number)
      expect(
        find('input[name="admin[email]"]').value
      ).to eq(@admin.email)
      expect(
        find('select[name="admin[employment_status_id]"]').value
      ).to eq("#{@admin.employment_status_id}")
      expect(
        find('select[name="admin[salary_system_id]"]').value
      ).to eq("#{@admin.salary_system_id}")
      expect(
        find('input[name="admin[wages]"]').value
      ).to eq("#{@admin.wages}")
      # 登録内容を編集する
      fill_in '社員番号', with: @edit_admin.number
      fill_in '姓', with: @edit_admin.last_name
      fill_in '名', with: @edit_admin.first_name
      find('select[name="admin[birth_date(1i)]"]').find("option[value='#{@edit_admin.birth_date.year}']").select_option
      find('select[name="admin[birth_date(2i)]"]').find("option[value='#{@edit_admin.birth_date.month}']").select_option
      find('select[name="admin[birth_date(3i)]"]').find("option[value='#{@edit_admin.birth_date.day}']").select_option
      fill_in '電話番号', with: @edit_admin.phone_number
      fill_in 'メールアドレス', with: @edit_admin.email
      fill_in '新しいパスワード', with: @edit_admin.password
      fill_in '新しいパスワード確認', with: @edit_admin.password
      find('select[name="admin[employment_status_id]"]').find("option[value='#{@edit_admin.employment_status_id}']").select_option
      find('select[name="admin[salary_system_id]"]').find("option[value='#{@edit_admin.salary_system_id}']").select_option
      fill_in '給与', with: @edit_admin.wages
      # 現在のパスワードを入力する
      fill_in '現在のパスワード', with: @admin.password
      # 編集してもAdminモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Admin.count }.by(0)
      # スタッフ一覧ページに遷移することを確認する
      expect(current_path).to eq(admins_home_path(@admin))
      # 先ほど変更した内容の責任者情報が存在することを確認する
      expect(page).to have_link "#{@edit_admin.number}", href: edit_admin_registration_path
      expect(page).to have_content(@edit_admin.last_name)
      expect(page).to have_content(@edit_admin.first_name)
      expect(page).to have_content(@edit_admin.employment_status.name)
      expect(page).to have_content(@edit_admin.salary_system.name)
      expect(page).to have_content(@edit_admin.birth_date)
    end
  end

  context '責任者情報が編集できないとき' do
    it '必須の情報を空にすると編集できない' do
      # トップページにアクセスするとログインページに遷移する
      visit root_path
      # 正しい責任者情報を入力する
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせると編集ボタンが表示されることを確認する
      expect(
        find('.user-menu').find('span').hover
      ).to have_content('編集')
      # 編集ページに移動する
      visit edit_admin_registration_path
      # 登録内容を編集する
      fill_in '社員番号', with: ''
      fill_in '姓', with: ''
      fill_in '名', with: ''
      find('select[name="admin[birth_date(1i)]"]').all("option[value]")[0].select_option
      find('select[name="admin[birth_date(2i)]"]').all("option[value]")[0].select_option
      find('select[name="admin[birth_date(3i)]"]').all("option[value]")[0].select_option
      find('select[name="admin[employment_status_id]"]').all("option[value]")[0].select_option
      find('select[name="admin[salary_system_id]"]').all("option[value]")[0].select_option
      # 現在のパスワードを入力する
      fill_in '現在のパスワード', with: @admin.password
      # 編集してもAdminモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Admin.count }.by(0)
      # 編集ページに戻ることを確認する
      expect(current_path).to eq(admin_registration_path)
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('エラーが発生')
    end
    it '現在のパスワードが一致しないと編集できない' do
      # トップページにアクセスするとログインページに遷移する
      visit root_path
      # 正しい責任者情報を入力する
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせると編集ボタンが表示されることを確認する
      expect(
        find('.user-menu').find('span').hover
      ).to have_content('編集')
      # 編集ページに移動する
      visit edit_admin_registration_path
      # 登録内容を編集する
      fill_in '社員番号', with: @edit_admin.number
      fill_in '姓', with: @edit_admin.last_name
      fill_in '名', with: @edit_admin.first_name
      # 現在のパスワードを入力する
      fill_in '現在のパスワード', with: ''
      # 編集してもAdminモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Admin.count }.by(0)
      # 編集ページに戻ることを確認する
      expect(current_path).to eq(admin_registration_path)
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('エラーが発生')
    end
  end
end

RSpec.describe "アカウントの削除", type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
  end

  context 'アカウントの削除ができるとき' do
    it 'ログインした責任者は紐付く全てのデータを削除できる' do
      # 責任者がログインする
      visit root_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # カーソルを合わせると編集ボタンが表示されることを確認する
      expect(
        find('.user-menu').find('span').hover
      ).to have_content('編集')
      # 編集ページに移動する
      visit edit_admin_registration_path
      # 「アカウント削除」ボタンを押すとWorkScheduleモデルのカウントが減ることを確認する
      expect {
        click_on 'アカウント削除'
        expect(page.driver.browser.switch_to.alert.text).to eq "責任者のデータを削除すると、全てのデータが削除されます"
        page.driver.browser.switch_to.alert.accept
        expect(current_path).to eq(new_admin_session_path)
      }.to change { Admin.count && Company.count }.by(-1)
    end
  end
end
