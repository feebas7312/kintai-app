require 'rails_helper'

RSpec.describe "スタッフの新規登録", type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
    @employee = FactoryBot.build(:employee)
    @employee2 = FactoryBot.create(:employee, admin_id: @admin.id)
  end

  context 'スタッフの新規登録ができるとき' do
    it 'ログインした責任者は自分の部下であるスタッフのアカウントを新規作成することができる' do
      # 責任者がログインする
      visit new_admin_session_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      # スタッフ一覧ページへのリンクがあることを確認する
      expect(page).to have_link 'スタッフ一覧', href: admins_home_path(@admin)
      # スタッフ一覧ページに移動する
      visit admins_home_path(@admin)
      # 「スタッフを追加」ボタンがあることを確認する
      expect(page).to have_link 'スタッフを追加', href: new_employee_registration_path
      # スタッフの新規登録ページに移動する
      visit new_employee_registration_path
      # 正しい情報を入力する
      fill_in '社員番号', with: @employee.number
      fill_in '姓', with: @employee.last_name
      fill_in '名', with: @employee.first_name
      find('select[name="employee[birth_date(1i)]"]').find("option[value='1987']").select_option
      find('select[name="employee[birth_date(2i)]"]').find("option[value='11']").select_option
      find('select[name="employee[birth_date(3i)]"]').find("option[value='11']").select_option
      fill_in '電話番号', with: @employee.phone_number
      fill_in 'メールアドレス', with: @employee.email
      fill_in 'employee[password]', with: @employee.password
      fill_in 'パスワード確認', with: @employee.password
      fill_in '入社日', with: @employee.joining_date
      find('select[name="employee[employment_status_id]"]').find("option[value='2']").select_option
      find('select[name="employee[salary_system_id]"]').find("option[value='2']").select_option
      fill_in '給与', with: @employee.wages
      # 登録ボタンを押すとEmployeeモデルのカウントが上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Employee.count }.by(1)
      # スタッフ一覧ページに遷移したことを確認する
      expect(current_path).to eq(admins_home_path(@admin))
      # 先ほど登録したスタッフの情報が存在することを確認する
      expect(page).to have_content(@employee.number)
    end
  end

  context 'スタッフの新規登録ができないとき' do
    it '誤ったスタッフ情報では新規登録ができずに新規登録ページに戻ってくる' do
      # 責任者がログインする
      visit new_admin_session_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      # スタッフ一覧ページへのリンクがあることを確認する
      expect(page).to have_link 'スタッフ一覧', href: admins_home_path(@admin)
      # スタッフ一覧ページに移動する
      visit admins_home_path(@admin)
      # 「スタッフを追加」ボタンがあることを確認する
      expect(page).to have_link 'スタッフを追加', href: new_employee_registration_path
      # スタッフの新規登録ページに移動する
      visit new_employee_registration_path
      # 正しい情報を入力する
      fill_in '社員番号', with: ''
      fill_in '姓', with: ''
      fill_in '名', with: ''
      find('select[name="employee[birth_date(1i)]"]').find("option[value='']").select_option
      find('select[name="employee[birth_date(2i)]"]').find("option[value='']").select_option
      find('select[name="employee[birth_date(3i)]"]').find("option[value='']").select_option
      fill_in '電話番号', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'employee[password]', with: ''
      fill_in 'パスワード確認', with: ''
      fill_in '入社日', with: ''
      find('select[name="employee[employment_status_id]"]').find("option[value='']").select_option
      find('select[name="employee[salary_system_id]"]').find("option[value='']").select_option
      fill_in '給与', with: ''
      # 登録ボタンを押してもEmployeeモデルのカウントが上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Employee.count }.by(0)
      # スタッフ新規登録ページに戻ったことを確認する
      expect(current_path).to eq(employee_registration_path)
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('エラーが発生')
      # 先ほど登録したスタッフの情報が存在することを確認する
      expect(page).to have_no_content(@employee.number)
    end
    it 'スタッフがログインしていると新規登録できない' do
      # スタッフがログインする
      visit new_employee_session_path
      fill_in '社員番号', with: @employee2.number
      fill_in 'パスワード', with: @employee2.password
      find('input[name="commit"]').click
      # スタッフ一覧ページへ移動する
      visit employees_home_path(@employee2)
      # 「スタッフを追加」ボタンがないことを確認する
      expect(page).to have_no_link 'スタッフを追加', href: new_employee_registration_path
    end
  end
end

RSpec.describe "ログイン", type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
    @employee = FactoryBot.create(:employee, admin_id: @admin.id)
  end

  context 'ログインできるとき' do
    it '保存されているスタッフの情報と合致すればログインができる' do
      # トップページにアクセスするとログインページに遷移する
      visit root_path
      # スタッフのログインページへのリンクがあることを確認する
      expect(page).to have_link 'スタッフの方はこちら', href: new_employee_session_path
      # スタッフのログインページに移動する
      visit new_employee_session_path
      # 正しい情報を入力する
      fill_in '社員番号', with: @employee.number
      fill_in 'パスワード', with: @employee.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # スタッフ用のスタッフ一覧ページに遷移することを確認する
      expect(current_path).to eq(employees_home_path(@employee))
    end
  end

  context 'ログインできないとき' do
    it '保存されているスタッフの情報と合致しないとログインができない' do
      # トップページにアクセスするとログインページに遷移する
      visit root_path
      # スタッフのログインページへのリンクがあることを確認する
      expect(page).to have_link 'スタッフの方はこちら', href: new_employee_session_path
      # スタッフのログインページに移動する
      visit new_employee_session_path
      # 情報を入力する
      fill_in '社員番号', with: ''
      fill_in 'パスワード', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページに戻ることを確認する
      expect(current_path).to eq(new_employee_session_path)
    end
  end
end

RSpec.describe "スタッフ情報の編集", type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
    @employee = FactoryBot.create(:employee, admin_id: @admin.id)
    @edit_employee = FactoryBot.build(:employee)
  end

  context 'スタッフ情報が編集できるとき' do
    it 'ログインしているスタッフは自分の登録情報を編集できる' do
      # スタッフがログインする
      visit new_employee_session_path
      fill_in '社員番号', with: @employee.number
      fill_in 'パスワード', with: @employee.password
      find('input[name="commit"]').click
      # スタッフ用のスタッフ一覧ページに遷移することを確認する
      expect(current_path).to eq(employees_home_path(@employee))
      # カーソルを合わせると編集ボタンが表示されることを確認する
      expect(
        find('.user-menu').find('span').hover
      ).to have_content('編集')
      # 編集ページに移動する
      visit edit_employee_registration_path
      # 既に登録済みの内容がフォームに入っていることを確認する
      expect(
        find('input[name="employee[last_name]"]').value
      ).to eq(@employee.last_name)
      expect(
        find('input[name="employee[first_name]"]').value
      ).to eq(@employee.first_name)
      expect(
        find('select[name="employee[birth_date(1i)]"]').value
      ).to eq("#{@employee.birth_date.year}")
      expect(
        find('select[name="employee[birth_date(2i)]"]').value
      ).to eq("#{@employee.birth_date.month}")
      expect(
        find('select[name="employee[birth_date(3i)]"]').value
      ).to eq("#{@employee.birth_date.day}")
      expect(
        find('input[name="employee[phone_number]"]').value
      ).to eq(@employee.phone_number)
      expect(
        find('input[name="employee[email]"]').value
      ).to eq(@employee.email)
      # 登録内容を編集する
      fill_in '姓', with: @edit_employee.last_name
      fill_in '名', with: @edit_employee.first_name
      find('select[name="employee[birth_date(1i)]"]').find("option[value='#{@edit_employee.birth_date.year}']").select_option
      find('select[name="employee[birth_date(2i)]"]').find("option[value='#{@edit_employee.birth_date.month}']").select_option
      find('select[name="employee[birth_date(3i)]"]').find("option[value='#{@edit_employee.birth_date.day}']").select_option
      fill_in '電話番号', with: @edit_employee.phone_number
      fill_in 'メールアドレス', with: @edit_employee.email
      fill_in '新しいパスワード', with: @edit_employee.password
      fill_in '新しいパスワード確認', with: @edit_employee.password
      # 現在のパスワードを入力する
      fill_in '現在のパスワード', with: @employee.password
      # 編集してもEmployeeモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Employee.count }.by(0)
      # スタッフ一覧ページに遷移することを確認する
      expect(current_path).to eq(employees_home_path(@employee))
      # 先ほど変更した内容の責任者情報が存在することを確認する
      expect(page).to have_content(@edit_employee.last_name)
      expect(page).to have_content(@edit_employee.first_name)
    end
    it 'ログインしている責任者は自分の部下の登録情報を編集できる' do
      # 責任者がログインする
      visit root_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # スタッフ一覧ページのリンクがあることを確認する
      expect(page).to have_link 'スタッフ一覧', href: admins_home_path(@admin)
      # スタッフ一覧ページへ移動する
      visit admins_home_path(@admin)
      # 部下のリストがあることを確認する
      expect(page).to have_link "#{@employee.number}", href: edit_employee_registration_path(employee_id: @employee.id)
      expect(page).to have_content(@employee.last_name)
      expect(page).to have_content(@employee.first_name)
      expect(page).to have_content(@employee.joining_date)
      expect(page).to have_content(@employee.employment_status.name)
      expect(page).to have_content(@employee.salary_system.name)
      expect(page).to have_content(@employee.birth_date)
      # スタッフの編集ページへ移動する
      visit edit_employee_registration_path(employee_id: @employee.id)
      # 既に登録済みの内容がフォームに入っていることを確認する
      expect(
        find('input[name="employee[number]"]').value
      ).to eq(@employee.number)
      expect(
        find('input[name="employee[last_name]"]').value
      ).to eq(@employee.last_name)
      expect(
        find('input[name="employee[first_name]"]').value
      ).to eq(@employee.first_name)
      expect(
        find('select[name="employee[birth_date(1i)]"]').value
      ).to eq("#{@employee.birth_date.year}")
      expect(
        find('select[name="employee[birth_date(2i)]"]').value
      ).to eq("#{@employee.birth_date.month}")
      expect(
        find('select[name="employee[birth_date(3i)]"]').value
      ).to eq("#{@employee.birth_date.day}")
      expect(
        find('input[name="employee[phone_number]"]').value
      ).to eq(@employee.phone_number)
      expect(
        find('select[name="employee[employment_status_id]"]').value
      ).to eq("#{@employee.employment_status_id}")
      expect(
        find('select[name="employee[salary_system_id]"]').value
      ).to eq("#{@employee.salary_system_id}")
      expect(
        find('input[name="employee[wages]"]').value
      ).to eq("#{@employee.wages}")
      # 登録内容を編集する
      fill_in '社員番号', with: @edit_employee.number
      fill_in '姓', with: @edit_employee.last_name
      fill_in '名', with: @edit_employee.first_name
      find('select[name="employee[birth_date(1i)]"]').find("option[value='#{@edit_employee.birth_date.year}']").select_option
      find('select[name="employee[birth_date(2i)]"]').find("option[value='#{@edit_employee.birth_date.month}']").select_option
      find('select[name="employee[birth_date(3i)]"]').find("option[value='#{@edit_employee.birth_date.day}']").select_option
      fill_in '電話番号', with: @edit_employee.phone_number
      find('select[name="employee[employment_status_id]"]').find("option[value='#{@edit_employee.employment_status_id}']").select_option
      find('select[name="employee[salary_system_id]"]').find("option[value='#{@edit_employee.salary_system_id}']").select_option
      fill_in '給与', with: @edit_employee.wages
      # 編集してもEmployeeモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Employee.count }.by(0)
      # スタッフ一覧ページに遷移することを確認する
      expect(current_path).to eq(admins_home_path(@admin))
      # 先ほど変更した内容の責任者情報が存在することを確認する
      expect(page).to have_link "#{@edit_employee.number}", href: edit_employee_registration_path(employee_id: @employee.id)
      expect(page).to have_content(@edit_employee.last_name)
      expect(page).to have_content(@edit_employee.first_name)
      expect(page).to have_content(@edit_employee.employment_status.name)
      expect(page).to have_content(@edit_employee.salary_system.name)
      expect(page).to have_content(@edit_employee.birth_date)
    end
  end

  context 'スタッフ情報が編集できないとき' do
    it 'スタッフ自身が編集時はパスワードが一致しないと編集できない' do
      # スタッフがログインする
      visit new_employee_session_path
      fill_in '社員番号', with: @employee.number
      fill_in 'パスワード', with: @employee.password
      find('input[name="commit"]').click
      # スタッフ用のスタッフ一覧ページに遷移することを確認する
      expect(current_path).to eq(employees_home_path(@employee))
      # カーソルを合わせると編集ボタンが表示されることを確認する
      expect(
        find('.user-menu').find('span').hover
      ).to have_content('編集')
      # 編集ページに移動する
      visit edit_employee_registration_path
      # 登録内容を編集する
      fill_in '姓', with: @edit_employee.last_name
      fill_in '名', with: @edit_employee.first_name
      # 現在のパスワードを入力する
      fill_in '現在のパスワード', with: ''
      # 編集してもEmployeeモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Employee.count }.by(0)
      # 編集ページに戻ることを確認する
      expect(current_path).to eq(employee_registration_path)
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('エラーが発生')
    end
    it '必須の情報を空にすると編集できない' do
      # 責任者がログインする
      visit root_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # スタッフ一覧ページのリンクがあることを確認する
      expect(page).to have_link 'スタッフ一覧', href: admins_home_path(@admin)
      # スタッフ一覧ページへ移動する
      visit admins_home_path(@admin)
      # 部下のリストがあることを確認する
      expect(page).to have_link "#{@employee.number}", href: edit_employee_registration_path(employee_id: @employee.id)
      expect(page).to have_content(@employee.last_name)
      expect(page).to have_content(@employee.first_name)
      expect(page).to have_content(@employee.joining_date)
      expect(page).to have_content(@employee.employment_status.name)
      expect(page).to have_content(@employee.salary_system.name)
      expect(page).to have_content(@employee.birth_date)
      # スタッフの編集ページへ移動する
      visit edit_employee_registration_path(employee_id: @employee.id)
      # 登録内容を編集する
      fill_in '社員番号', with: ''
      fill_in '姓', with: ''
      fill_in '名', with: ''
      find('select[name="employee[birth_date(1i)]"]').all("option[value]")[0].select_option
      find('select[name="employee[birth_date(2i)]"]').all("option[value]")[0].select_option
      find('select[name="employee[birth_date(3i)]"]').all("option[value]")[0].select_option
      find('select[name="employee[employment_status_id]"]').all("option[value]")[0].select_option
      find('select[name="employee[salary_system_id]"]').all("option[value]")[0].select_option
      # 編集してもEmployeeモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Employee.count }.by(0)
      # 編集ページに戻ることを確認する
      expect(current_path).to eq(employee_registration_path)
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('エラーが発生')
    end
  end
end