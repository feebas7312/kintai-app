require 'rails_helper'

RSpec.describe "出勤パターンの新規作成", type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
    @employee = FactoryBot.create(:employee, admin_id: @admin.id)
    @work_pattern = FactoryBot.build(:work_pattern)
  end

  context '出勤パターンの新規作成ができるとき' do
    it 'ログインした責任者は出勤パターンの作成ができる' do
      # 責任者がログインする
      visit new_admin_session_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      # 会社情報ページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # 「パターン追加」ボタンがあることを確認する
      expect(page).to have_link 'パターン追加', href: new_company_work_pattern_path(@company)
      # 出勤パターン作成ページに移動する
      visit new_company_work_pattern_path(@company)
      # 正しく情報を入力する
      fill_in 'work_pattern[start_time]', with: @work_pattern.start_time
      fill_in 'work_pattern[end_time]', with: @work_pattern.end_time
      fill_in 'work_pattern[break_time]', with: @work_pattern.break_time
      # 登録ボタンを押すとWorkPatternモデルのカウントが上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { WorkPattern.count }.by(1)
      # トップページに移動したことを確認する
      expect(current_path).to eq(root_path)
      # 先ほど変更した内容の出勤パターンが存在することを確認する
      expect(page).to have_content(@work_pattern.start_time)
      expect(page).to have_content(@work_pattern.end_time)
      expect(page).to have_content(@work_pattern.break_time)
    end
  end

  context '出勤パターンの新規作成ができないとき' do
    it '誤った出勤パターン情報では作成ができずに新規作成ページに戻ってくる' do
      # 責任者がログインする
      visit new_admin_session_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      # 会社情報ページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # 「パターン追加」ボタンがあることを確認する
      expect(page).to have_link 'パターン追加', href: new_company_work_pattern_path(@company)
      # 出勤パターン作成ページに移動する
      visit new_company_work_pattern_path(@company)
      # 情報を入力する
      fill_in 'work_pattern[start_time]', with: ''
      fill_in 'work_pattern[end_time]', with: ''
      fill_in 'work_pattern[break_time]', with: ''
      # 登録ボタンを押してもWorkPatternモデルのカウントが上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { WorkPattern.count }.by(0)
      # 出勤パターン作成ページに戻ったことを確認する
      expect(current_path).to eq("/companies/#{@company.id}/work_patterns")
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('エラーが発生')
    end
    it 'スタッフがログインしていると新規登録できない' do
      # スタッフがログインする
      visit new_employee_session_path
      fill_in '社員番号', with: @employee.number
      fill_in 'パスワード', with: @employee.password
      find('input[name="commit"]').click
      # スタッフ一覧ページへ移動する
      visit employees_home_path(@employee)
      # 「スタッフを追加」ボタンがないことを確認する
      expect(page).to have_no_link 'パターン追加', href: new_company_work_pattern_path(@company)
    end
  end
end

RSpec.describe "出勤パターンの削除", type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
    @employee = FactoryBot.create(:employee, admin_id: @admin.id)
    @work_pattern = FactoryBot.create(:work_pattern, company_id: @company.id)
  end

  context '出勤パターンが削除できるとき' do
    it 'ログインした責任者は自分が作成した出勤パターンを削除できる' do
      # 責任者がログインする
      visit new_admin_session_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      # 会社情報ページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # 出勤パターン一覧があることを確認する
      expect(page).to have_content('出勤パターン一覧')
      # 削除ボタンを押すとWorkPatternモデルのカウントが減ることを確認する
      expect{
        all('a[class="btn"]')[0].click
      }.to change { WorkPattern.count }.by(-1)
      # 会社情報ページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # 先ほど削除した出勤パターンの表示がなくなっていることを確認する
      expect(page).to have_no_content(@work_pattern.start_time)
      expect(page).to have_no_content(@work_pattern.end_time)
      expect(page).to have_no_content(@work_pattern.break_time)
    end
  end

  context '出勤パターンが削除できないとき' do
    it 'スタッフがログインしていると新規登録できない' do
      # スタッフがログインする
      visit new_employee_session_path
      fill_in '社員番号', with: @employee.number
      fill_in 'パスワード', with: @employee.password
      find('input[name="commit"]').click
      # スタッフ用のスタッフ一覧ページに遷移することを確認する
      expect(current_path).to eq(employees_home_path(@employee))
      # 出勤パターン一覧がないことを確認する
      expect(page).to have_no_content('出勤パターン一覧')
    end
  end
end