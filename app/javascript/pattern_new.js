function workTimeCalc(){
  const patternForm = document.getElementById("pattern-form");
  const workTimeDisp = document.getElementById("work-time-disp");
  const workTime = document.getElementById("work-time");

  if (!workTime.value) {
    workTimeDisp.value = 0;
    workTime.value = 0;
  } else {
    workTimeDisp.value = (workTime.value / 60).toLocaleString(undefined, { maximumFractionDigits: 3 });
  }

  patternForm.addEventListener('input', function(){
    const startTime = document.getElementById("start-time").value;
    const endTime = document.getElementById("end-time").value;
    const breakTime = document.getElementById("break-time").value;

    if (startTime.length === 4 && endTime.length === 4) {
      const startTimeMinute = Number(startTime.slice(0,2)) * 60 + Number(startTime.slice(2,4));
      const endTimeMinute = Number(endTime.slice(0,2)) * 60 + Number(endTime.slice(2,4));
      const workTimeMinute = endTimeMinute - startTimeMinute - breakTime;
      workTimeDisp.value = (workTimeMinute / 60).toLocaleString(undefined, { maximumFractionDigits: 3 });
      workTime.value = workTimeMinute;
    } else {
      workTimeDisp.value = 0;
      workTime.value = 0;
    }
  });

};
window.addEventListener('load', workTimeCalc);