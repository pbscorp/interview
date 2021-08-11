
              
                var aryBlnRequired = document.querySelectorAll('.blnRequired');
                var aryBlnResponseBtnChecked = document.querySelectorAll('.blnResponseBtnChecked');
                var aryScore = document.querySelectorAll('.score');
                var aryWeight = document.querySelectorAll('.weight');
                var aryTotStdWt = document.querySelectorAll('.totStdWt');
                var aryTotWt = document.querySelectorAll('.totWt');
                var aryRunWt = document.querySelectorAll('.runWt');
                var aryRunScore = document.querySelectorAll('.runScore');
                var aryAvg=document.querySelectorAll('.avg');
                var aryAvgSpan=document.querySelectorAll('.avgSpan');
                var aryGradesWt = document.getElementById('lstGradesWt').value.split(',');
                var intMaxGrades = Math.max(...aryGradesWt);
                var intTotQuizWt = 0;
                var intTotQuizStdWt = 0;
                var intTotQuizScore = 0;
                function fncCalcQuiz(n_intCurRow, n_intResponse) {
                    console.clear();
                    console.log('n_intCurRow = ' + n_intCurRow);
                    intTotQuizWt = 0;
                    intTotQuizStdWt = 0;
                    intTotQuizScore = 0;
                    let i;
                    if (n_intCurRow != undefined) {
                        i = n_intCurRow;
                        console.log('n_intCurRow = ' + i);
                        aryScore[i].value = aryGradesWt[parseInt(n_intResponse) -1];
                        aryBlnResponseBtnChecked[i].value = 1;
                    }
                    for ( i=0;  i < aryScore.length; i++) {

                        if ( (aryBlnResponseBtnChecked[i].value == 1) && (aryScore[i].value > 0) || (aryBlnRequired[i].value == 1)  ) {
                            intTotQuizStdWt += parseInt(aryWeight[i].value) * intMaxGrades;// maxamum score possible
                        }
                        aryTotWt[i].value = 0;
                        if ( aryBlnResponseBtnChecked[i].value == 1 ) {
                            aryTotWt[i].value =  aryScore[i].value * aryWeight[i].value;
                            intTotQuizWt += parseInt(aryTotWt[i].value);
                        }
                        aryRunWt[i].value =  intTotQuizWt;
                        aryTotStdWt[i].value =  intTotQuizStdWt;
                    }
                    for ( i=0;  i < aryScore.length; i++) {
                        aryRunScore[i].value =  intTotQuizWt;
                        aryTotStdWt[i].value =  intTotQuizStdWt;
                        if (intTotQuizStdWt != 0){
                            aryAvg[i].value =  Math.round( intTotQuizWt / intTotQuizStdWt * 100);
                        }
                        aryAvgSpan[i].innerText = aryAvg[i].value;
                        if (n_intCurRow == i) {
                            console.log('n_intCurRow = ' + i);
                            console.log('aryBlnResponseBtnChecked = ' + aryBlnResponseBtnChecked[i].value);
                            console.log('aryBlnRequired = ' + aryBlnRequired[i].value);
                            console.log('aryScore = ' + aryScore[i].value);
                            console.log('aryWeight = ' + aryWeight[i].value);
                            console.log('aryTotStdWt = ' + aryTotStdWt[i].value);
                            console.log('aryTotWt = ' + aryTotWt[i].value);
                            console.log('aryRunWt = ' + aryRunWt[i].value);
                            console.log('aryRunScore = ' + aryRunScore[i].value);
                            console.log('aryAvg = ' + aryAvg[i].value);
                            console.log('aryGradesWt = ' + aryAvgSpan[i].value);
                        }
                    }
                    console.log('intMaxGrades = ' + intMaxGrades);
                    console.log('intTotQuizWt = ' + intTotQuizWt);
                    console.log('intTotQuizStdWt = ' + intTotQuizStdWt);
                    console.log('intTotQuizScore = ' + intTotQuizScore);
                }
                fncCalcQuiz();