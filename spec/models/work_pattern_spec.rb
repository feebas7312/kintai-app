require 'rails_helper'

RSpec.describe WorkPattern, type: :model do
  before do
    company = FactoryBot.create(:company)
    @work_pattern = FactoryBot.build(:work_pattern, company_id: company.id)
  end

  describe '出勤パターンの登録' do
    context '登録がうまくいくとき' do
      it '全ての情報が正しく入力されていれば登録できる' do
        expect(@work_pattern).to be_valid
      end
    end
    context '登録がうまくいかないとき' do
      it 'start_timeが空では登録できない' do
        @work_pattern.start_time = ''
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('出勤時間を半角数字4桁で入力してください')
      end
      it 'start_timeが3桁以下だと登録できない' do
        @work_pattern.start_time = Faker::Number.number(digits: 3)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('出勤時間を半角数字4桁で入力してください')
      end
      it 'start_timeが5桁以上だと登録できない' do
        @work_pattern.start_time = Faker::Number.number(digits: 5)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('出勤時間を半角数字4桁で入力してください')
      end
      it 'start_timeが全角では保存できない' do
        @work_pattern.start_time = @work_pattern.start_time.tr('0-9', '０-９')
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('出勤時間を半角数字4桁で入力してください')
      end
      it 'start_timeに文字列が含まれていると登録できない' do
        @work_pattern.start_time = Faker::Lorem.characters(number: 4, min_alpha: 1)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('出勤時間を半角数字4桁で入力してください')
      end
      it 'end_timeが空では登録できない' do
        @work_pattern.end_time = ''
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('退勤時間を半角数字4桁で入力してください')
      end
      it 'end_timeが3桁以下だと登録できない' do
        @work_pattern.end_time = Faker::Number.number(digits: 3)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('退勤時間を半角数字4桁で入力してください')
      end
      it 'end_timeが5桁以上だと登録できない' do
        @work_pattern.end_time = Faker::Number.number(digits: 5)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('退勤時間を半角数字4桁で入力してください')
      end
      it 'end_timeが全角では保存できない' do
        @work_pattern.end_time = @work_pattern.end_time.tr('0-9', '０-９')
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('退勤時間を半角数字4桁で入力してください')
      end
      it 'end_timeに文字列が含まれていると登録できない' do
        @work_pattern.end_time = Faker::Lorem.characters(number: 4, min_alpha: 1)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('退勤時間を半角数字4桁で入力してください')
      end
      it 'break_timeが空では登録できない' do
        @work_pattern.break_time = ''
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('休憩時間の入力が正しくありません')
      end
      it 'break_timeが1,000分以上だと登録できない' do
        @work_pattern.break_time = Faker::Number.between(from: 1000)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('休憩時間の入力が正しくありません')
      end
      it 'break_timeが全角では保存できない' do
        @work_pattern.break_time = @work_pattern.break_time.to_s.tr('0-9', '０-９')
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('休憩時間の入力が正しくありません')
      end
      it 'break_timeに文字列が含まれていると登録できない' do
        @work_pattern.break_time = Faker::Lorem.characters(number: 4, min_alpha: 1)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('休憩時間の入力が正しくありません')
      end
      it 'work_timeが481分以上のとき、break_timeが60分未満では登録できない' do
        @work_pattern.work_time = Faker::Number.between(from: 481)
        @work_pattern.break_time = Faker::Number.between(to: 59)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('休憩時間は60分以上に設定してください')
      end
      it 'work_timeが361分以上のとき、break_timeが45分未満では登録できない' do
        @work_pattern.work_time = Faker::Number.between(from: 361, to: 480)
        @work_pattern.break_time = Faker::Number.between(to: 44)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('休憩時間は45分以上に設定してください')
      end
      it 'work_timeが空では登録できない' do
        @work_pattern.work_time = ''
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('労働時間が不正です')
      end
      it 'work_timeが661分以上だと登録できない' do
        @work_pattern.work_time = Faker::Number.between(from: 661)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('労働時間が不正です')
      end
      it 'work_timeが全角では保存できない' do
        @work_pattern.work_time = @work_pattern.work_time.to_s.tr('0-9', '０-９')
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('労働時間が不正です')
      end
      it 'work_timeに文字列が含まれていると登録できない' do
        @work_pattern.work_time = Faker::Lorem.characters(number: 4, min_alpha: 1)
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('労働時間が不正です')
      end
      it 'company_idが紐付いていないと登録できない' do
        @work_pattern.company = nil
        @work_pattern.valid?
        expect(@work_pattern.errors.full_messages).to include('所属会社を入力してください')
      end
    end
  end
end
