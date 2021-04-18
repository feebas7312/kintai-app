function workTimeCalc(){
  const scheduleFormMonth = document.querySelectorAll(".month-input-field");
  const submitBtn = document.getElementById("js-submit");

  // loadイベント（起動時の計算）
  scheduleFormMonth.forEach(function(monthForm){
    const monthTotal = monthForm.childNodes[11];
    let monthTotalCalc = 0;
    const monthChildren = Array.from(monthForm.childNodes);
    const scheduleFormWeek = monthChildren.filter(function(child){
      return child.className === "week-input-field";
    });

    scheduleFormWeek.forEach(function(weekForm){
      const weekTotal = weekForm.childNodes[weekForm.childNodes.length-2];
      let weekTotalCalc = 0;
      const weekChildren = Array.from(weekForm.childNodes);
      const scheduleFormDay = weekChildren.filter(function(child){
        return child.className === "input-field";
      });

      scheduleFormDay.forEach(function(form){
        const startTime = form.childNodes[5].value;
        const endTime = form.childNodes[7].value;
        const breakTime = form.childNodes[9].value;
        const workTime = form.childNodes[11];
        if (startTime.length === 4 && endTime.length === 4) {
          const startTimeMinute = Number(startTime.slice(0,2)) * 60 + Number(startTime.slice(2,4));
          const endTimeMinute = Number(endTime.slice(0,2)) * 60 + Number(endTime.slice(2,4));
          const workTimeMinute = endTimeMinute - startTimeMinute - breakTime;
          workTime.value = workTimeMinute;
        } else {
          workTime.value = 0;
        }
        weekTotalCalc += Number(workTime.value);
      });

      weekTotal.value = (weekTotalCalc / 60).toLocaleString(undefined, { maximumFractionDigits: 1 }) + "時間";
      monthTotalCalc += weekTotalCalc;
    });

    monthTotal.value = (monthTotalCalc / 60).toLocaleString(undefined, { maximumFractionDigits: 1 }) + "時間";
  });


  // inputイベント（入力を変更した時の計算）
  scheduleFormMonth.forEach( function(monthForm) {
    monthForm.addEventListener('input', function() {
      const monthTotal = monthForm.childNodes[11];
      let monthTotalCalc = 0;
      const monthChildren = Array.from(monthForm.childNodes);
      const scheduleFormWeek = monthChildren.filter( function(child) {
        return child.className === "week-input-field";
      });

      scheduleFormWeek.forEach( function(weekForm) {
        const weekTotal = weekForm.childNodes[weekForm.childNodes.length-2];
        let weekTotalCalc = 0;
        const weekChildren = Array.from(weekForm.childNodes);
        const scheduleFormDay = weekChildren.filter( function(child) {
          return child.className === "input-field";
        });

        scheduleFormDay.forEach( function(form) {
          const startTime = form.childNodes[5].value;
          const endTime = form.childNodes[7].value;
          const breakTime = form.childNodes[9].value;
          const workTime = form.childNodes[11];
          if (startTime.length === 4 && endTime.length === 4) {
            const startTimeMinute = Number(startTime.slice(0,2)) * 60 + Number(startTime.slice(2,4));
            const endTimeMinute = Number(endTime.slice(0,2)) * 60 + Number(endTime.slice(2,4));
            const workTimeMinute = endTimeMinute - startTimeMinute - breakTime;

            // 休憩時間が法定外だったら文字を赤くする
            if ((workTimeMinute > 480 && breakTime < 60) || (workTimeMinute > 360 && breakTime < 45)) {
              form.childNodes[5].setAttribute("style", "color: red; font-weight: bold;");
              form.childNodes[7].setAttribute("style", "color: red; font-weight: bold;");
              form.childNodes[9].setAttribute("style", "color: red; font-weight: bold;");
            } else {
              form.childNodes[5].removeAttribute("style", "color: red; font-weight: bold;");
              form.childNodes[7].removeAttribute("style", "color: red; font-weight: bold;");
              form.childNodes[9].removeAttribute("style", "color: red; font-weight: bold;");
            }

            workTime.value = workTimeMinute;
          } else {
            workTime.value = 0;
          }
          weekTotalCalc += Number(workTime.value);
        });

        weekTotal.value = (weekTotalCalc / 60).toLocaleString(undefined, { maximumFractionDigits: 1 }) + "時間";

        // 週の労働時間の合計がオーバーしていたら文字を赤くする
        if ((scheduleFormDay.length == 7 && weekTotalCalc > 2400) || (scheduleFormDay.length < 10 && weekTotalCalc > 2880) || (scheduleFormDay.length == 10 && weekTotalCalc > 3360)) {
          weekTotal.setAttribute("style", "color: red; font-weight: bold;");
        } else {
          weekTotal.removeAttribute("style", "color: red; font-weight: bold;");
        }
        monthTotalCalc += weekTotalCalc;
      });

      monthTotal.value = (monthTotalCalc / 60).toLocaleString(undefined, { maximumFractionDigits: 1 }) + "時間";

      // 全てのスタイルを確認して、真偽の配列を生成
      let styleArray = [];
      const dayTimeArray = document.querySelectorAll(".js-field");
      dayTimeArray.forEach( function(dayTime) {
        styleArray.push(dayTime.getAttribute("style") !== "color: red; font-weight: bold;")
      });
      const weekTimeArray = document.querySelectorAll(".work-time__week-total");
      weekTimeArray.forEach( function(weekTime) {
        styleArray.push(weekTime.getAttribute("style") !== "color: red; font-weight: bold;")
      });

      // 上記の配列に一つでもfalseがあればsubmitボタンを無効化する
      if (styleArray.every( function(value) { return value })) {
        submitBtn.disabled = false;
        submitBtn.removeAttribute("style", "opacity: 0.5;");
      } else {
        submitBtn.disabled = true;
        submitBtn.setAttribute("style", "opacity: 0.5;");
      }
    });
  });

};
window.addEventListener('load', workTimeCalc);