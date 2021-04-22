require 'rails_helper'

RSpec.describe Company, type: :model do
  before do
    @company = FactoryBot.build(:company)
  end

  describe '会社情報の登録' do
    context '登録がうまくいくとき' do
      it '全ての情報が正しく入力されていれば登録できる' do
        expect(@company).to be_valid
      end
      it 'postal_code, address, phone_numberは空でも登録できる' do
        @company.postal_code = ''
        @company.address = ''
        @company.phone_number = ''
        expect(@company).to be_valid
      end
    end

    context '登録がうまくいかないとき' do
      it 'nameが空では登録できない' do
        @company.name = ''
        @company.valid?
        expect(@company.errors.full_messages).to include('会社名を入力してください')
      end
      it 'postal_codeにハイフンがないと購入できない' do
        @company.postal_code = Faker::Number.number(digits: 7)
        @company.valid?
        expect(@company.errors.full_messages).to include('郵便番号を正しく入力してください')
      end
      it 'phone_numberが9桁以下だと登録できない' do
        @company.phone_number = Faker::Number.number(digits: 9)
        @company.valid?
        expect(@company.errors.full_messages).to include('電話番号を数字のみで入力してください')
      end
      it 'phone_numberが12桁以上だと登録できない' do
        @company.phone_number = Faker::Number.number(digits: 12)
        @company.valid?
        expect(@company.errors.full_messages).to include('電話番号を数字のみで入力してください')
      end
      it 'cutoff_date_idが空では登録できない' do
        @company.cutoff_date_id = ''
        @company.valid?
        expect(@company.errors.full_messages).to include('締日を選択してください')
      end
      it 'opening_timeが空では登録できない' do
        @company.opening_time = ''
        @company.valid?
        expect(@company.errors.full_messages).to include('開店時間を入力してください')
      end
      it 'closing_timeが空では登録できない' do
        @company.closing_time = ''
        @company.valid?
        expect(@company.errors.full_messages).to include('閉店時間を入力してください')
      end
    end
  end
end
