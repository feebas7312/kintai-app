require 'rails_helper'

RSpec.describe "勤務計画作成", type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
    @employee1 = FactoryBot.create(:employee, admin_id: @admin.id)
    @employee2 = FactoryBot.create(:employee, admin_id: @admin.id)
    @work_pattern = FactoryBot.create(:work_pattern, company_id: @company.id)
  end

  context '勤務計画を作成できるとき' do
    it 'ログインした責任者は新規作成できる' do
      # ログインする
      visit new_admin_session_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 勤務計画作成ページへのリンクがあることを確認する
      expect(page).to have_link '勤務計画作成', href: new_work_schedule_path
      # 勤務計画作成ページに移動する
      visit new_work_schedule_path
      # フォームに情報を入力する
      fill_in 'start-time00', with: @work_pattern.start_time
      fill_in 'end-time00', with: @work_pattern.end_time
      fill_in 'break-time00', with: @work_pattern.break_time
      # 保存するとWorkScheduleモデルのカウントが上がることを確認する
      expect{
        all('input[name="commit"]')[1].click
      }.to change { WorkSchedule.count }.by(Date.today.end_of_month.day*3)
      # 「保存が完了しました」の文字があることを確認する
      expect(page).to have_content('保存が完了しました')
      # 勤務計画一覧ページに移動する
      visit work_schedules_path
      # 先ほど保存した内容の勤務計画があることを確認する
      expect(page).to have_content(@work_pattern.start_time)
    end
  end

  context '勤務計画を作成できないとき' do
    it 'スタッフでログインすると勤務計画を作成できない' do
      # スタッフでログインする
      visit new_employee_session_path
      fill_in '社員番号', with: @employee1.number
      fill_in 'パスワード', with: @employee1.password
      find('input[name="commit"]').click
      expect(current_path).to eq(employees_home_path(@employee1))
      # 勤務計画作成ページへのリンクがないことを確認する
      expect(page).to have_no_link '勤務計画作成', href: new_work_schedule_path
    end
  end
end

RSpec.describe '勤務計画編集', type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
    @employee1 = FactoryBot.create(:employee, admin_id: @admin.id)
    @employee2 = FactoryBot.create(:employee, admin_id: @admin.id)
    @work_pattern = FactoryBot.create(:work_pattern, company_id: @company.id)
  end

  context '勤務計画が編集できるとき' do
    it 'ログインした責任者は自分のチームの勤務計画の編集ができる' do
      # 責任者でログインする
      visit new_admin_session_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 勤務計画を作成する
      expect(page).to have_link '勤務計画作成', href: new_work_schedule_path
      visit new_work_schedule_path
      expect{
        all('input[name="commit"]')[1].click
      }.to change { WorkSchedule.count }.by(Date.today.end_of_month.day*3)
      expect(page).to have_content('保存が完了しました')
      # もう一度、勤務計画作成ページへ遷移する
      visit new_work_schedule_path
      # 入力内容を編集する
      fill_in 'start-time00', with: @work_pattern.start_time
      fill_in 'end-time00', with: @work_pattern.end_time
      fill_in 'break-time00', with: @work_pattern.break_time
      # 編集してもWorkScheduleモデルのカウントは変わらないことを確認する
      expect{
        all('input[name="commit"]')[1].click
      }.to change { WorkSchedule.count }.by(0)
      # 「保存が完了しました」の文字があることを確認する
      expect(page).to have_content('保存が完了しました')
      # 勤務計画一覧ページに移動する
      visit work_schedules_path
      # 先ほど保存した内容の勤務計画があることを確認する
      expect(page).to have_content(@work_pattern.start_time)
    end
  end

  context '勤務計画が編集できないとき' do
    it 'スタッフでログインすると勤務計画を編集できない' do
      # スタッフでログインする
      visit new_employee_session_path
      fill_in '社員番号', with: @employee1.number
      fill_in 'パスワード', with: @employee1.password
      find('input[name="commit"]').click
      expect(current_path).to eq(employees_home_path(@employee1))
      # 勤務計画作成ページへのリンクがないことを確認する
      expect(page).to have_no_link '勤務計画作成', href: new_work_schedule_path
    end
  end
end

RSpec.describe '勤務計画削除', type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
    @employee1 = FactoryBot.create(:employee, admin_id: @admin.id)
    @employee2 = FactoryBot.create(:employee, admin_id: @admin.id)
    @work_pattern = FactoryBot.create(:work_pattern, company_id: @company.id)
  end

  context '勤務計画を削除できるとき' do
    it 'ログインした責任者は自分のチームの勤務計画の削除ができる' do
      # 責任者でログインする
      visit new_admin_session_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      expect(current_path).to eq(root_path)
      # 勤務計画を作成する
      expect(page).to have_link '勤務計画作成', href: new_work_schedule_path
      visit new_work_schedule_path
      fill_in 'start-time00', with: @work_pattern.start_time
      fill_in 'end-time00', with: @work_pattern.end_time
      fill_in 'break-time00', with: @work_pattern.break_time
      expect{
        all('input[name="commit"]')[1].click
      }.to change { WorkSchedule.count }.by(Date.today.end_of_month.day*3)
      expect(page).to have_content('保存が完了しました')
      # もう一度、勤務計画作成ページへ遷移する
      visit new_work_schedule_path
      # 削除ボタンを押すとWorkScheduleモデルのカウントが減ることを確認する
      expect {
        all('a[class="btn"]')[0].click
        expect(page.driver.browser.switch_to.alert.text).to eq "データを削除します"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content('削除しました')
      }.to change { WorkSchedule.count }.by(-Date.today.end_of_month.day*3)
      # 勤務計画一覧ページに移動する
      visit work_schedules_path
      # 先ほど保存した内容の勤務計画があることを確認する
      expect(page).to have_no_content(@work_pattern.start_time)
    end
  end

  context '勤務計画を削除できないとき' do
    it 'スタッフでログインすると勤務計画を作成できない' do
      # スタッフでログインする
      visit new_employee_session_path
      fill_in '社員番号', with: @employee1.number
      fill_in 'パスワード', with: @employee1.password
      find('input[name="commit"]').click
      expect(current_path).to eq(employees_home_path(@employee1))
      # 勤務計画作成ページへのリンクがないことを確認する
      expect(page).to have_no_link '勤務計画作成', href: new_work_schedule_path
    end
  end
end