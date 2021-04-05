function workTimeCalc(){
  const scheduleFormMonth = document.querySelectorAll(".month-input-field");

  scheduleFormMonth.forEach( function(monthForm) {   // 一人ずつ計算
    const monthTotal = monthForm.childNodes[11];     // 最後ここに月の合計労働時間を入れる
    let monthTotalCalc = 0;
    const monthChildren = Array.from(monthForm.childNodes);   // 1ヶ月分のフォームを配列形式で取得
    const scheduleFormWeek = monthChildren.filter( function(child) {
      return child.className === "week-input-field";
    });

    scheduleFormWeek.forEach( function(weekForm) {   // 週ごとに計算
      const weekTotal = weekForm.childNodes[weekForm.childNodes.length-2];   // 最後ここに週の合計労働時間を入れる
      let weekTotalCalc = 0;
      const weekChildren = Array.from(weekForm.childNodes);   // 1週間分のフォームを配列形式で取得
      const scheduleFormDay = weekChildren.filter( function(child) {
        return child.className === "input-field";
      });

      scheduleFormDay.forEach( function(form) {   // 一日ごとに労働時間を計算
        const formChild = form.childNodes[1];
        if (formChild.childNodes[5]) {
          weekTotalCalc += Number(formChild.childNodes[5].innerHTML);   // 休日でなければ労働時間を加算
        }
      });

      weekTotal.innerHTML = (weekTotalCalc / 60).toLocaleString(undefined, { maximumFractionDigits: 1 }) + "時間"; // 週の合計を代入
      monthTotalCalc += weekTotalCalc;
    });

    monthTotal.innerHTML = (monthTotalCalc / 60).toLocaleString(undefined, { maximumFractionDigits: 1 }) + "時間"; // 月の合計を代入
  });

};
window.addEventListener('load', workTimeCalc);