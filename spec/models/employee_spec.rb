require 'rails_helper'

RSpec.describe Employee, type: :model do
  before do
    @employee = FactoryBot.build(:employee)
  end

  describe 'スタッフの新規登録' do
    context '新規登録がうまくいくとき' do
      it '全ての情報が正しく入力されていれば登録できる' do
        expect(@employee).to be_valid
      end
      it 'phone_number, email, wagesは空でも登録できる' do
        @employee.phone_number = ''
        @employee.email = ''
        @employee.wages = ''
        expect(@employee).to be_valid
      end
    end
    context '新規登録がうまくいかないとき' do
      it 'numberが空では登録できない' do
        @employee.number = ''
        @employee.valid?
        expect(@employee.errors.full_messages).to include('社員番号を入力してください')
      end
      it 'last_nameが空では登録できない' do
        @employee.last_name = ''
        @employee.valid?
        expect(@employee.errors.full_messages).to include('姓を入力してください') 
      end
      it 'first_nameが空では登録できない' do
        @employee.first_name = ''
        @employee.valid?
        expect(@employee.errors.full_messages).to include('名を入力してください') 
      end
      it 'birth_dateが空では登録できない' do
        @employee.birth_date = ''
        @employee.valid?
        expect(@employee.errors.full_messages).to include('生年月日を入力してください') 
      end
      it 'phone_numberが9桁以下だと登録できない' do
        @employee.phone_number = Faker::Number.number(digits: 9)
        @employee.valid?
        expect(@employee.errors.full_messages).to include('電話番号を数字のみで入力してください')
      end
      it 'phone_numberが12桁以上だと登録できない' do
        @employee.phone_number = Faker::Number.number(digits: 12)
        @employee.valid?
        expect(@employee.errors.full_messages).to include('電話番号を数字のみで入力してください')
      end
      it '既に同じemailが登録されている場合は登録できない' do
        @employee.save
        anothor_employee = FactoryBot.build(:employee)
        anothor_employee.email = @employee.email
        anothor_employee.valid?
        expect(anothor_employee.errors.full_messages).to include('Eメールはすでに存在します')
      end
      it 'emailに「＠」を含まなければ登録できない' do
        @employee.email = 'aaa'
        @employee.valid?
        expect(@employee.errors.full_messages).to include('Eメールは不正な値です')
      end
      it 'passwordが空では登録できない' do
        @employee.password = ''
        @employee.valid?
        expect(@employee.errors.full_messages).to include('パスワードを入力してください') 
      end
      it 'passwordが5文字以下では登録できない' do
        @employee.password = Faker::Lorem.characters(number: 5, min_alpha: 1, min_numeric: 1)
        @employee.password_confirmation = @employee.password
        @employee.valid?
        expect(@employee.errors.full_messages).to include('パスワードは6文字以上で入力してください')
      end
      it 'passwordが存在してもpassword_confirmationが空では登録できない' do
        @employee.password_confirmation = ''
        @employee.valid?
        expect(@employee.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
      it 'passwordとpassword_confirmationが一致しなければ登録できない' do
        @employee.password = Faker::Lorem.characters(number: 6, min_alpha: 1, min_numeric: 1)
        @employee.password_confirmation = Faker::Lorem.characters(number: 7, min_alpha: 1, min_numeric: 1)
        @employee.valid?
        expect(@employee.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
      it 'joining_dateが空では登録できない' do
        @employee.joining_date = ''
        @employee.valid?
        expect(@employee.errors.full_messages).to include('入社日を入力してください') 
      end
      it 'employment_status_idが空では登録できない' do
        @employee.employment_status_id = ''
        @employee.valid?
        expect(@employee.errors.full_messages).to include('雇用形態を選択してください') 
      end
      it 'salary_system_idが空では登録できない' do
        @employee.salary_system_id = ''
        @employee.valid?
        expect(@employee.errors.full_messages).to include('給与体系を選択してください') 
      end
      it 'adminが紐付いていないと登録できない' do
        @employee.admin = nil
        @employee.valid?
        expect(@employee.errors.full_messages).to include('責任者を入力してください')
      end
      it 'adminとnumberが両方同じ場合は登録できない' do
        @employee.save
        anothor_employee = FactoryBot.build(:employee)
        anothor_employee.number = @employee.number
        anothor_employee.admin = @employee.admin
        anothor_employee.valid?
        expect(anothor_employee.errors.full_messages).to include('社員番号が重複しています')
      end
    end
  end
end
