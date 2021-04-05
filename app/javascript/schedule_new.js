function workTimeCalc(){
  const scheduleFormMonth = document.querySelectorAll(".month-input-field");

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
  });

};
window.addEventListener('load', workTimeCalc);