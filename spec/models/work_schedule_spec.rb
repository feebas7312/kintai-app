require 'rails_helper'

RSpec.describe WorkSchedule, type: :model do
  before do
    admin = FactoryBot.create(:admin)
    @work_schedule = FactoryBot.build(:work_schedule, admin_id: admin.id)
  end

  describe '勤務計画の登録' do
    context '登録がうまくいくとき' do
      it '全ての情報が正しく入力されていれば登録できる' do
        expect(@work_schedule).to be_valid
      end
      it 'start_timeとend_timeの両方が空の場合は登録できる' do
        @work_schedule.start_time = ''
        @work_schedule.end_time = ''
        expect(@work_schedule).to be_valid
      end
      it 'start_timeとend_timeの両方が空の場合は、break_timeも空で登録できる' do
        @work_schedule.start_time = ''
        @work_schedule.end_time = ''
        @work_schedule.break_time = ''
        expect(@work_schedule).to be_valid
      end
    end
    context '登録がうまくいかないとき' do
      it 'start_timeとend_timeのどちらか一方だけの入力では登録できない（start_timeだけの場合）' do
        @work_schedule.start_time = ''
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('出勤時間を半角数字4桁で入力してください')
      end
      it 'start_timeが3桁以下だと登録できない' do
        @work_schedule.start_time = Faker::Number.number(digits: 3)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('出勤時間を半角数字4桁で入力してください')
      end
      it 'start_timeが5桁以上だと登録できない' do
        @work_schedule.start_time = Faker::Number.number(digits: 5)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('出勤時間を半角数字4桁で入力してください')
      end
      it 'start_timeが全角では保存できない' do
        @work_schedule.start_time = @work_schedule.start_time.tr('0-9', '０-９')
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('出勤時間を半角数字4桁で入力してください')
      end
      it 'start_timeに文字列が含まれていると登録できない' do
        @work_schedule.start_time = Faker::Lorem.characters(number: 4, min_alpha: 1)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('出勤時間を半角数字4桁で入力してください')
      end
      it 'start_timeとend_timeのどちらか一方だけの入力では登録できない（end_timeだけの場合）' do
        @work_schedule.end_time = ''
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('退勤時間を半角数字4桁で入力してください')
      end
      it 'end_timeが3桁以下だと登録できない' do
        @work_schedule.end_time = Faker::Number.number(digits: 3)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('退勤時間を半角数字4桁で入力してください')
      end
      it 'end_timeが5桁以上だと登録できない' do
        @work_schedule.end_time = Faker::Number.number(digits: 5)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('退勤時間を半角数字4桁で入力してください')
      end
      it 'end_timeが全角では保存できない' do
        @work_schedule.end_time = @work_schedule.end_time.tr('0-9', '０-９')
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('退勤時間を半角数字4桁で入力してください')
      end
      it 'end_timeに文字列が含まれていると登録できない' do
        @work_schedule.end_time = Faker::Lorem.characters(number: 4, min_alpha: 1)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('退勤時間を半角数字4桁で入力してください')
      end
      it 'start_timeとend_timeが入力されている場合、break_timeが空では登録できない' do
        @work_schedule.break_time = ''
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('休憩時間を入力してください')
      end
      it 'break_timeが1,000分以上だと登録できない' do
        @work_schedule.break_time = Faker::Number.between(from: 1000)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('休憩時間の入力が正しくありません')
      end
      it 'break_timeが全角では保存できない' do
        @work_schedule.break_time = @work_schedule.break_time.to_s.tr('0-9', '０-９')
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('休憩時間の入力が正しくありません')
      end
      it 'break_timeに文字列が含まれていると登録できない' do
        @work_schedule.break_time = Faker::Lorem.characters(number: 4, min_alpha: 1)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('休憩時間の入力が正しくありません')
      end
      it 'work_timeが481分以上のとき、break_timeが60分未満では登録できない' do
        @work_schedule.work_time = Faker::Number.between(from: 481)
        @work_schedule.break_time = Faker::Number.between(to: 59)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('休憩時間は60分以上に設定してください')
      end
      it 'work_timeが361分以上のとき、break_timeが45分未満では登録できない' do
        @work_schedule.work_time = Faker::Number.within(range: 361..480)
        @work_schedule.break_time = Faker::Number.between(to: 44)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('休憩時間は45分以上に設定してください')
      end
      it 'work_timeが空では登録できない' do
        @work_schedule.work_time = ''
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('労働時間が不正です')
      end
      it 'work_timeが661分以上だと登録できない' do
        @work_schedule.work_time = Faker::Number.between(from: 661)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('労働時間が不正です')
      end
      it 'work_timeが全角では保存できない' do
        @work_schedule.work_time = @work_schedule.work_time.to_s.tr('0-9', '０-９')
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('労働時間が不正です')
      end
      it 'work_timeに文字列が含まれていると登録できない' do
        @work_schedule.work_time = Faker::Lorem.characters(number: 4, min_alpha: 1)
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('労働時間が不正です')
      end
      it 'admin_idまたはemployee_idが紐付いていないと登録できない' do
        @work_schedule.admin_id = nil
        @work_schedule.employee_id = nil
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('誰の勤務計画かわかりません')
      end
      it 'admin_idとemployee_idの2つが紐付いていると登録できない' do
        @work_schedule.admin_id = 1
        @work_schedule.employee_id = 2
        @work_schedule.valid?
        expect(@work_schedule.errors.full_messages).to include('2人のスタッフIDが紐付いています')
      end
    end
  end
end
