document.addEventListener("DOMContentLoaded", () => {
  console.log("日付スクリプトが読み込まれました！");

  // `select` の取得方法を修正
  const yearSelect = document.querySelector("select[data-date-year]");
  const monthSelect = document.querySelector("select[data-date-month]");
  const daySelect = document.querySelector("select[data-date-day]");
  const output = document.querySelector("#formatted-work-date");

  console.log("yearSelect:", yearSelect);
  console.log("monthSelect:", monthSelect);
  console.log("daySelect:", daySelect);

  if (!yearSelect || !monthSelect || !daySelect || !output) {
    console.log("日付要素が見つかりませんでした。");
    return;
  }

  function updateFormattedDate() {
    const year = yearSelect.value;
    const month = monthSelect.value;
    const day = daySelect.value;

    if (!year || !month || !day) return;

    const date = new Date(year, month - 1, day); // 月は 0 から始まる
    const weekdays = [
      "日曜日",
      "月曜日",
      "火曜日",
      "水曜日",
      "木曜日",
      "金曜日",
      "土曜日",
    ];
    const formattedDate = `${year} 年 ${month} 月 ${day} 日 (${
      weekdays[date.getDay()]
    })`;

    output.textContent = formattedDate;
  }

  yearSelect.addEventListener("change", updateFormattedDate);
  monthSelect.addEventListener("change", updateFormattedDate);
  daySelect.addEventListener("change", updateFormattedDate);

  updateFormattedDate(); // 初期表示
});
