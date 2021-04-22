require 'rails_helper'

RSpec.describe Admin, type: :model do
  before do
    @admin = FactoryBot.build(:admin)
  end

  describe '責任者の新規登録' do
    context '新規登録がうまくいくとき' do
      it '全ての情報が正しく入力されていれば登録できる' do
        expect(@admin).to be_valid
      end
      it 'phone_number, email, wagesは空でも登録できる' do
        @admin.phone_number = ''
        @admin.email = ''
        @admin.wages = ''
        expect(@admin).to be_valid
      end
    end
    context '新規登録がうまくいかないとき' do
      it 'numberが空では登録できない' do
        @admin.number = ''
        @admin.valid?
        expect(@admin.errors.full_messages).to include('社員番号を入力してください')
      end
      it 'last_nameが空では登録できない' do
        @admin.last_name = ''
        @admin.valid?
        expect(@admin.errors.full_messages).to include('姓を入力してください') 
      end
      it 'first_nameが空では登録できない' do
        @admin.first_name = ''
        @admin.valid?
        expect(@admin.errors.full_messages).to include('名を入力してください') 
      end
      it 'birth_dateが空では登録できない' do
        @admin.birth_date = ''
        @admin.valid?
        expect(@admin.errors.full_messages).to include('生年月日を入力してください') 
      end
      it 'phone_numberが9桁以下だと登録できない' do
        @admin.phone_number = Faker::Number.number(digits: 9)
        @admin.valid?
        expect(@admin.errors.full_messages).to include('電話番号を数字のみで入力してください')
      end
      it 'phone_numberが12桁以上だと登録できない' do
        @admin.phone_number = Faker::Number.number(digits: 12)
        @admin.valid?
        expect(@admin.errors.full_messages).to include('電話番号を数字のみで入力してください')
      end
      it '既に同じemailが登録されている場合は登録できない' do
        @admin.save
        anothor_admin = FactoryBot.build(:admin)
        anothor_admin.email = @admin.email
        anothor_admin.valid?
        expect(anothor_admin.errors.full_messages).to include('Eメールはすでに存在します')
      end
      it 'emailに「＠」を含まなければ登録できない' do
        @admin.email = 'aaa'
        @admin.valid?
        expect(@admin.errors.full_messages).to include('Eメールは不正な値です')
      end
      it 'passwordが空では登録できない' do
        @admin.password = ''
        @admin.valid?
        expect(@admin.errors.full_messages).to include('パスワードを入力してください') 
      end
      it 'passwordが5文字以下では登録できない' do
        @admin.password = Faker::Lorem.characters(number: 5, min_alpha: 1, min_numeric: 1)
        @admin.password_confirmation = @admin.password
        @admin.valid?
        expect(@admin.errors.full_messages).to include('パスワードは6文字以上で入力してください')
      end
      it 'passwordが存在してもpassword_confirmationが空では登録できない' do
        @admin.password_confirmation = ''
        @admin.valid?
        expect(@admin.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
      it 'passwordとpassword_confirmationが一致しなければ登録できない' do
        @admin.password = Faker::Lorem.characters(number: 6, min_alpha: 1, min_numeric: 1)
        @admin.password_confirmation = Faker::Lorem.characters(number: 7, min_alpha: 1, min_numeric: 1)
        @admin.valid?
        expect(@admin.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
      it 'joining_dateが空では登録できない' do
        @admin.joining_date = ''
        @admin.valid?
        expect(@admin.errors.full_messages).to include('入社日を入力してください') 
      end
      it 'employment_status_idが空では登録できない' do
        @admin.employment_status_id = ''
        @admin.valid?
        expect(@admin.errors.full_messages).to include('雇用形態を選択してください') 
      end
      it 'salary_system_idが空では登録できない' do
        @admin.salary_system_id = ''
        @admin.valid?
        expect(@admin.errors.full_messages).to include('給与体系を選択してください') 
      end
    end
  end
end
