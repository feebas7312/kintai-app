require 'rails_helper'

RSpec.describe "会社情報の編集", type: :system do
  before do
    @admin = FactoryBot.create(:admin)
    @company = FactoryBot.create(:company, admin_id: @admin.id)
    @employee = FactoryBot.create(:employee, admin_id: @admin.id)
  end

  context '会社情報の編集ができるとき' do
    it 'ログインした責任者は自分が所属する会社情報を編集できる' do
      # 責任者がログインする
      visit new_admin_session_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      # 会社情報ページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # 「会社情報編集」ボタンがあることを確認する
      expect(page).to have_link '会社情報編集', href: edit_company_path(@admin)
      # 会社情報編集ページに移動する
      visit edit_company_path(@admin)
      # 既に登録済みの内容がフォームに入っていることを確認する
      expect(
        find('input[name="company[name]"]').value
      ).to eq(@company.name)
      expect(
        find('input[name="company[postal_code]"]').value
      ).to eq(@company.postal_code)
      expect(
        find('input[name="company[address]"]').value
      ).to eq(@company.address)
      expect(
        find('input[name="company[phone_number]"]').value
      ).to eq(@company.phone_number)
      expect(
        find('input[name="company[opening_time]"]').value
      ).to eq(@company.opening_time.strftime('%H:%M:%S.%L'))
      expect(
        find('input[name="company[closing_time]"]').value
      ).to eq(@company.closing_time.strftime('%H:%M:%S.%L'))
      # 登録内容を編集する
      fill_in '会社名', with: '編集テスト'
      fill_in '郵便番号', with: '123-4567'
      fill_in '所在地', with: '編集テスト'
      fill_in '電話番号', with: '08012345678'
      fill_in '開店時間', with: '07:00:00'
      fill_in '閉店時間', with: '23:00:00'
      # 編集してもCompanyモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Company.count }.by(0)
      # 会社情報ページに遷移することを確認する
      expect(current_path).to eq(company_path(@admin))
      # 先ほど変更した内容の会社情報が存在することを確認する
      expect(page).to have_content('編集テスト')
    end
  end

  context '会社情報の編集ができないとき' do
    it '必須の情報を空にすると編集できない' do
      # 責任者がログインする
      visit new_admin_session_path
      fill_in '社員番号', with: @admin.number
      fill_in 'パスワード', with: @admin.password
      find('input[name="commit"]').click
      # 会社情報ページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # 「会社情報編集」ボタンがあることを確認する
      expect(page).to have_link '会社情報編集', href: edit_company_path(@admin)
      # 会社情報編集ページに移動する
      visit edit_company_path(@admin)
      # 既に登録済みの内容がフォームに入っていることを確認する
      expect(
        find('input[name="company[name]"]').value
      ).to eq(@company.name)
      expect(
        find('input[name="company[postal_code]"]').value
      ).to eq(@company.postal_code)
      expect(
        find('input[name="company[address]"]').value
      ).to eq(@company.address)
      expect(
        find('input[name="company[phone_number]"]').value
      ).to eq(@company.phone_number)
      expect(
        find('input[name="company[opening_time]"]').value
      ).to eq(@company.opening_time.strftime('%H:%M:%S.%L'))
      expect(
        find('input[name="company[closing_time]"]').value
      ).to eq(@company.closing_time.strftime('%H:%M:%S.%L'))
      # 登録内容を編集する
      fill_in '会社名', with: ''
      fill_in '郵便番号', with: '123-4567'
      fill_in '所在地', with: '編集テスト'
      fill_in '電話番号', with: '08012345678'
      fill_in '開店時間', with: ''
      fill_in '閉店時間', with: ''
      # 編集してもCompanyモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Company.count }.by(0)
      # 会社情報編集ページに戻ることを確認する
      expect(current_path).to eq(company_path(@admin.company))
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('エラーが発生')
    end
    it 'スタッフがログインしていると編集できない' do
      # スタッフがログインする
      visit new_employee_session_path
      fill_in '社員番号', with: @employee.number
      fill_in 'パスワード', with: @employee.password
      find('input[name="commit"]').click
      # スタッフ一覧ページへ遷移することを確認する
      expect(current_path).to eq(employees_home_path(@employee))
      # 「スタッフを追加」ボタンがないことを確認する
      expect(page).to have_no_link '会社情報編集', href: edit_company_path(@admin)
    end
  end
end
