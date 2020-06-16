require.config({
    paths: {
        jquery: "./jquery/jquery.min",
        jedate: "./jedate/jquery.jedate",
        config: "./config",
        ajax: "./modules/ajax",
        util: "./modules/util",
        mianyang:'./echart/mianyang',
    }
});
require([
    "jquery",
    "config",
    "ajax",
    'mianyang',
], function() {
    $(function() {
        var token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.ZXlKcGNDSTZJalV4TWk0MU1USXVOVEV5TGpVeE1pSXNJbVY0Y0NJNk1UVTJORFUxTmpJeU9EVTFNWDA9DQo.yw-PovMQ-I_LyRFso1fvB6W5kQpIN_8bz9nRsw4EtzY';
        var j = 0;
        var colors2 = ['#09e265', '#ff4e4e', '#edbf3c'];
        var loadingParams = {
            text: 'loading',
            color: '#c23531',
            textColor: '#f00',
            maskColor: '#111e6a',
            zlevel: 7
        }
        var flag = true;
        var flag1 = true;
        var flag2 = true;
        var flag3 = true;
        var flag4 = true;
        var flag5 = true;
        var flag6 = true;
        var flag7 = true;
        var time1 = 20;
        var time2 = 20;
        var time3 = 20;
        var time4 = 20;
        var time5 = 20;
        var time6 = 20;
        var time7 = 20;
        var timer1 = null;
        var timer2 = null;
        var timer21 = null;
        var timer3 = null;
        var timer4 = null;
        var timer5 = null;
        var timer51 = null;
        var timer6 = null;
        var timer61 = null;
        var timer7 = null;
        var tokenTimer = null;
        var data2 = [];
        var data5 = [];
        var data6 = [];
        var logout = [];
        var online = [];
        var offline = [];
        var hide = [];
        var myChart1 = echarts.init(document.getElementById('chart1'));
        var myChart2 = echarts.init(document.getElementById('chart2'));
        var myChart3 = echarts.init(document.getElementById('chart3'));
        var myChart4 = echarts.init(document.getElementById('chart4'));
        var myChart5 = echarts.init(document.getElementById('chart5'));
        var myChart6 = echarts.init(document.getElementById('chart6'));
        var myChart7 = echarts.init(document.getElementById('chart7'));
        var _data1 = [];
        var _data2 = [];
        var _data3 = [];
        var _data4 = [];
        var _data5 = [];
        var _data6 = [];
        var _data7 = [];
        function getNowFormatDate() {
            var date = new Date();
            var seperator1 = "-";
            var seperator2 = ":";
            var h = date.getHours()
            var m = date.getMinutes()
            var s = date.getSeconds()
            if (h >= 0 && h <= 9) {
                h = "0" + h;
            }
            if (m >= 0 && m <= 9) {
                m = "0" + m;
            }
            if (s >= 0 && s <= 9) {
                s = "0" + s;
            }
            var currentdate = h + seperator2 + m + seperator2 + s;
            $('.Exh_header .time').text(currentdate)
        }
        setInterval(function(){
            getNowFormatDate()
        },1000)
        var color = [
            [0.083, '#8676d8'],
            [0.167, '#8676d8'],
            [0.25, '#8676d8'],
            [0.333, '#8676d8'],
            [0.417, '#8676d8'],
            [0.5, '#8676d8'],
            [0.583, '#8676d8'],
            [0.667, '#8676d8'],
            [0.75, '#8676d8'],
            [0.833, '#8676d8'],
            [0.917, '#8676d8'],
            [1, '#8676d8'],
        ];
        // getToken()
        getChart1();
        getChart2();
        getChart3();
        getChart4();
        getChart7();
        getChart5();
        getChart6();
        function getToken(){
            var opts = {
                url: request.tokenUrl + request.getToken,
                type: "get",
                data:{
                    action:'gettoken',
                    name:'myqdzhzcptadmin'//shadmin
                },

                successCb: function(result) {
                    token = result;
                    if(flag){
                        getChart1();
                        getChart2();
                        getChart3();
                        getChart4();
                        getChart7();
                    }
                    clearInterval(tokenTimer)
                    tokenTimer = setInterval(getToken,3600000)
                },
                errorCb: function(err) {

                },
                completeCb: function() {
                    console.log("complete");
                }
            }
            req.requst(opts)
        }
        var option1 = {
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            color: ['#ce2e6b', '#cd00d8', '#931800', '#0cbcaf', '#009dad', '#20b0fb','#b8c100','#c17f00'],
            legend: {
                type: 'scroll',
                orient: 'vertical',
                x: 'right',
                itemWidth: 20,
                itemHeight:10,
                itemGap: 5,
                y:'center',
                pageIconSize: 8,
                pageTextStyle:{
                    normal:{
                        color:'#fff'
                    }
                },
                textStyle: {
                    color: '#fff',
                    fontSize: 8
                },
                data: []
            },
            series: [{
                name: '工单类型占比',
                type: 'pie',
                radius: '45%',
                center: ['43%', '50%'],
                data: [],
                label: {
                    normal: {
                        formatter: '{b}：{c}  ({d}%)  ',
                        fontSize: 10
                    }
                },

                itemStyle: {
                    emphasis: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    },
                },
                labelLine:{
                    normal:{
                        show:true,
                        length: 5,
                        length2: 5
                    }
                },
            }]
        };
        var option2 = {
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'shadow'
                }
            },
            legend: {
                data: ['平均首响时长（秒）'],
                textStyle: {
                    color: '#7d82ba'
                }
            },
            xAxis: {
                type: 'category',
                data: [],
                axisLabel: {
                    formatter: function(params){
                        return params.substr(0,10);
                    },
                    color:'#c8cfe4',
                    interval:0
                },
                axisLine:{
                    lineStyle:{
                        color:'#124aff',
                        width:1,
                    }
                },
                axisTick:{
                    alignWithLabel: true
                }
            },
            yAxis: {
                show: false,
                type: 'value',
                axisLabel: {
                    color: '#7d82ba'
                },
                splitLine: {
                    show: false
                }
            },
            label: {
                normal: {
                  show: true,
                  position: 'top',
                  textStyle: {
                    color: '#f00'
                  }
                }
            },
            series: [{
                    name: '首响时长（秒）',
                    type: 'bar',
                    stack: '总量',
                    barMaxWidth: 40,
                    label: {
                        normal: {
                            show: false,
                            position: 'insideRight'
                        }
                    },
                    itemStyle: {
                        normal: {
                            color: '#09e265'
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            formatter: function(params){
                                var val = Number(params.value).toFixed(2);
                                return fomatVerg(val)
                            },
                            position: "top",
                            textStyle: {
                                color: "#ffc72b",
                                fontSize: 12
                            }
                        }
                    },
                     markLine: {
                        itemStyle: {
                            normal: {
                                lineStyle: {
                                    type: 'dashed',
                                    color: '#e4960d ',
                                    width: 1,
                                },

                                label: {
                                    position: 'end',
                                    textStyle: {
                                        fontSize: 12,
                                    },
                                },
                            },

                        },
                    },
                    data: []
                }
            ]
        };
        
        var option3 = {
            tooltip: {
                trigger: 'axis'
            },
            axisLine:{
                lineStyle:{
                    color: '#124aff'
                }
            },
            xAxis: {
                type: 'category',
                nameTextStyle:{
                    color: '#fff'
                },
                data: [],
                axisLabel: {
                    formatter: '{value}',
                    color:'#c8cfe4',
                    interval:0
                },
                axisLine:{
                    lineStyle:{
                        color:'#124aff',
                        width:1,
                    }
                },
                axisTick:{
                    alignWithLabel: true
                }
            },
            yAxis: {
                type: 'value',
                splitLine:{
                    show:false
                },
                axisLabel: {
                    formatter: '{value}',
                    color:'#c8cfe4'
                },
                axisLine:{
                    lineStyle:{
                        color:'#124aff',
                        width:1,
                    }
                } 
            },
            series: [{
                    name: '支撑成功率',
                    type: 'line',
                    data: [],
                    lineStyle:{
                        color:'#b818d4'
                    },
                    markLine: {
                        itemStyle: {
                            normal: {
                                lineStyle: {
                                    type: 'dashed',
                                    color: '#e4960d ',
                                    width: 1,
                                },
                            },

                        },
                        data: [{
                            type: 'average',
                            name: '平均值'
                        }]
                    }
                },

            ]
        };
        
        var option4 = {
            series: [{
                name: "待处理工单最大量",
                type: 'gauge',
                radius: '95%',
                min: 0,
                max: 1000,
                axisLine: {
                    lineStyle: {
                        color: color,
                        width: 1
                    }
                },
                splitNumber: 10,
                splitLine: {
                    show:false,
                    length: 10
                },
                axisTick: {
                    show:false,
                    length: 5
                },
                axisLabel: {
                    show: true,
                    distance: 0,
                    color:'#9ec6fa' 
                },
                itemStyle: {
                    normal:{
                        color:'#fff'
                    }
                },
                title: {
                    fontSize: 20,
                    color: "#7d82ba"
                },
                pointer: {
                    // show:false,
                    width: 5
                },
                detail: {
                    show:false,
                    formatter: '{value}',
                    offsetCenter: [0, '50%'],
                    fontSize: 12
                },
                data: [{ value: 0, name: '' }]
            },
            {
                name: "待处理工单最大量",
                type: 'gauge',
                radius: '60%',
                z:1,
                axisLine: {
                    show: true,
                    lineStyle: {
                      width: 10,
                      color: [
                        [
                          0.98, new echarts.graphic.LinearGradient(
                          0, 0, 1, 0, [{
                          offset: 0,
                          color: '#e5160b'
                        },
                          {
                            offset: 1,
                            color: '#2ecf10'
                          }
                        ]
                          )
                        ],
                        [
                          1, '#222e7d'
                        ]
                      ]
                    }
                },
                splitLine: {
                    show:false,
                    length: 10
                },
                axisTick: {
                    show:false,
                    length: 5
                },
                axisLabel: {
                    show: false,
                },
                itemStyle: {

                },
                title: {
                    fontSize: 14,
                    color: "#7d82ba"
                },
                pointer: {
                    show:true,
                    width: 2
                },
                detail: {
                    formatter: function() {
                        return "待处理工单最大量   "
                    },
                    offsetCenter: [0, '140%'],
                    fontSize: 12,
                    color: '#fff'
                },
                data: []
            }
            ]
        };

        var option5 = {
            tooltip: {
                trigger: 'axis',
                formatter:function(params){
                    console.log(params)
                    return params[0].seriesName + ':' + fomatVerg(params[0].value)
                },
                axisPointer: { 
                    type: 'shadow'
                }
            },
            legend: {
                data: ['平均首响时长（秒）'],
                textStyle: {
                    color: '#7d82ba'
                }
            },
            grid: {
                left: '2%',
                right: '10%',
                bottom: '20%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                data: [],
                axisLabel: {
                    formatter: function(params){
                        return params.substr(0,10);
                    },
                    color:'#c8cfe4',
                    interval:0
                },
                axisLine:{
                    lineStyle:{
                        color:'#124aff',
                        width:1,
                    }
                },
                axisTick:{
                    alignWithLabel: true
                }
            },
            yAxis: {
                show: false,
                type: 'value',
                axisLabel: {
                    color: '#7d82ba'
                },
                splitLine: {
                    show: false
                }
            },
            label: {
                normal: {
                  show: true,
                  position: 'top',
                  textStyle: {
                    color: '#f00'
                  }
                }
            },
            series: [{
                    name: '服务满意度',
                    type: 'bar',
                    label: {
                        normal: {
                            show: false,
                            position: 'insideRight'
                        }
                    },
                    barMaxWidth: 40,
                    itemStyle: {
                        normal: {
                            color: '#c1ce0c'
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            formatter: function(params){
                                var val = Number(params.value).toFixed(2);
                                return fomatVerg(val)
                            },
                            position: "top",
                            textStyle: {
                                color: "#ffc72b",
                                fontSize: 12
                            }
                        }
                    },
                    markLine: { 
                        itemStyle: {
                            normal: {
                                lineStyle: {
                                    type: 'dashed',
                                    color: '#2fa7a6 ',
                                    width: 1,
                                },

                                label: {
                                    position: 'end',
                                    textStyle: {
                                        fontSize: 12,
                                    },
                                },
                            },

                        },
                        data: [
                            {
                                name: '平均线',
                                type: 'average'
                            }
                        ],

                    },
                    data: []
                }
            ]
        };
        
        var option6 = {
             legend: {
                 data: ['平均首响时长（秒）'],
                 textStyle: {
                     color: '#7d82ba'
                 }
             },
             grid: {
                 left: '2%',
                 right: '10%',
                 bottom: '20%',
                 containLabel: true
             },
             xAxis: {
                 type: 'category',
                 data: [],
                 axisLabel: {
                    formatter: function(params){
                        return params.substr(0,10);
                    },
                    color:'#c8cfe4',
                    interval:0
                 },
                 axisLine:{
                     lineStyle:{
                         color:'#124aff',
                         width:1,
                     }
                 },
                 axisTick:{
                    alignWithLabel: true
                }
             },
             yAxis: {
                 show: false,
                 type: 'value',
                 axisLabel: {
                     color: '#7d82ba'
                 },
                 splitLine: {
                     show: false
                 }
             },
             series: [{
                     name: '状态',
                     type: 'bar',
                     barMaxWidth: 40,
                     label: {
                         normal: {
                             show: false,
                             position: 'insideRight'
                         }
                     },
                     itemStyle: {
                         normal: {
                             color: '#09e265'
                         }
                     },
                     data: []
                 }
             ]
        };

        echarts.registerMap('zhongguo', mianyang);
        var geoCoordMap = {
            "安州区": [104.3159656, 31.55248824],
            "北川羌族自治县": [104.198064, 31.9248824],
            "涪城区": [104.777755556, 31.403461713],
            "高新区": [104.5582144804688, 31.43779274726563],
            "江油市": [104.9734572, 31.9774129],
            "平武县": [104.534788, 32.41577],
            "三台县": [105.01007117, 31.097788],
            "盐亭县": [105.388825, 31.213983],
            "游仙区": [104.874722, 31.6588814],
            "梓潼县": [105.181856, 31.67464831],
        }

        var convertData = function(data,n) {
            var res = [];
            for (var i = 0; i < data.length; i++) {
                var geoCoord = geoCoordMap[data[i].name];
                if (geoCoord) {
                    res.push({
                        name: data[i].name,
                        value: geoCoord.concat(data[i].value)
                    });
                }
            }
            return res;
        };
        var option7 = {
            
            tooltip: {
                trigger: 'item',
            },
            legend: {
                orient: 'vertical',
                y: 'bottom',
                x: 'right',
                data: ['sell_area'],
                textStyle: {
                    color: '#fff'
                }
            },
            visualMap: {
                show: true,
                min: 0,
                right: '5%',
                top: 'bottom',
                text: ['高', '低'], 
                calculable: true,
                seriesIndex: [1,2],
                itemHeight: 100,
                inRange: {
                    color: ['#c05050','#e5cf0d','#5ab1ef']

                },
                textStyle: {
                    color: '#fff'
                }
            },
            geo: {
                show: true,
                map: 'zhongguo',
                left: '10%',
                right: '8%',
                top: '3%',
                bottom: "32%",
                label: {
                    normal: {
                        show: false
                    },
                    emphasis: {
                        show: false,
                    }
                },
                roam: false,

                itemStyle: {
                    normal: {
                        areaColor: '#0442d3',
                        borderColor: '#749eff',
                        borderWidth: 2,
                        shadowColor: 'rgba(63, 218, 255, 0.5)',
                        shadowBlur: 30
                    },
                    emphasis: {
                        areaColor: '#2B91B7',
                    }
                }
            },
            series: [
                {
                    type: 'map',
                    z: 1,
                    map: 'zhongguo',
                    geoIndex: 0,
                    aspectScale: 0.7, 
                    showLegendSymbol: false,
                    label: {
                        normal: {
                            show: false
                        },
                        emphasis: {
                            show: false,
                            textStyle: {
                                color: '#fff'
                            }
                        }
                    },
                    itemStyle: {
                        normal: {
                            areaColor: '#031525',
                            borderColor: '#3B5077',
                        },
                        emphasis: {
                            areaColor: '#2B91B7'
                        }
                    },
                    animation: false,
                },
                {
                    name: '工单占比',
                    z: 2,
                    type: 'pie',
                    radius: '20%',
                    center: ['45%', '85%'],
                    label: {
                        normal: {
                            show: true,
                            formatter: '{b}：{c} ({d}%)  '
                        },
                        emphasis: {
                            show: true,
                        }
                    },
                    itemStyle: {
                        emphasis: {
                        }
                    },
                },
                {
                    name: '点',
                    // z: 5,
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    symbol: 'pin',
                    symbolSize: function(val) {
                        return 70
                    },
                    label: {
                        normal: {
                            show: true,
                            textStyle: {
                                color: '#fff',
                                fontSize: 14,
                            }
                        }
                    },
                    itemStyle: {
                        normal: {
                            color: '#F62157',
                        }
                    },
                    zlevel: 5,
                },
                {
                    name: '',
                    type: 'effectScatter',
                    coordinateSystem: 'geo',
                    symbolSize: function(val) {
                        return 20
                    },
                    showEffectOn: 'render',
                    rippleEffect: {
                        brushType: 'stroke'
                    },
                    hoverAnimation: true,
                    label: {
                        normal: {
                            formatter: '{b}',
                            position: 'right',
                            show: false
                        }
                    },
                    itemStyle: {
                        normal: {
                            color: '#05C3F9',
                            shadowBlur: 10,
                            shadowColor: '#05C3F9'
                        }
                    },
                    zlevel: 4
                },
                {
                    name: 'credit_pm2.5',
                    type: 'scatter',
                    coordinateSystem: 'geo',
                    symbolSize: function(val) {
                        return 10
                    },
                    label: {
                        normal: {
                            formatter: '{b}',
                            position: 'right',
                            show: true
                        },
                        emphasis: {
                            show: true
                        }
                    },
                    itemStyle: {
                        normal: {
                            color: '#fff'
                        }
                    }
                },
                
            ]
        };
        myChart7.setOption(option7);

        myChart1.setOption(option1);
        myChart2.setOption(option2);
        myChart3.setOption(option3);
        myChart4.setOption(option4);
        myChart5.setOption(option5);
        myChart6.setOption(option6);
        myChart1.showLoading(loadingParams);
        myChart3.showLoading(loadingParams);
        myChart4.showLoading(loadingParams);
        myChart5.showLoading(loadingParams);
        myChart6.showLoading(loadingParams);
        myChart2.showLoading(loadingParams);
        myChart6.showLoading(loadingParams);
        myChart7.showLoading(loadingParams);
        function setChart1(data){
            var nameArr = [];
            var valueArr = [];
            for (var i = 0; i < data.length; i++) {
                var o = {}
                o.name = data[i].Name;
                o.value = data[i].Count;
                nameArr.push(data[i].Name)
                valueArr.push(o)
            }
            
            myChart1.setOption({
                legend: {
                    data: nameArr
                },
                series: [{
                    data: valueArr,
                    
                }]
            })
        }
        function setChart2(data){
            var total = 0
            var max = 0;
            for (var i = 0; i < data.length; i++) {
                total += Number(data[i].Average)
                if(Number(data[i].Average) > max) {
                    max = Number(data[i].Average)
                }
            }
            var percent = data.length ? (total / data.length).toFixed(2) : "";
            percent = percent ? fomatVerg(percent)  : "*";
            $('.myzc_res .ratio').text(percent +'秒')
            $('.myzc_res').show();
            formdata2(data,percent,max); 
        }
        function setChart3(data){
            var nameArr = [];
            var valueArr = [];
            var k = 0;
            for (var i = 0; i < data.length; i++) {
                nameArr.push(data[i].Hour+'点')
                valueArr.push(data[i].Percent)
                k += Number(data[i].Percent)
            }
            var percent = (k / data.length).toFixed(2);
            percent = fomatVerg(percent);
            
            $('.myzc_ratio .ratio').text(percent+'%')
            $('.myzc_ratio').show();
            myChart3.setOption({
                title:{
                    subText: percent
                },
                xAxis: {
                    data: nameArr
                },
                series: [{
                    data: valueArr
                    
                }]
            })
        }
        function setChart4(result){
            var num = Number(result.Data);
            var number = 0;
            if(num <= 100 ){
                number = Math.floor(num/10)*10 + 20
            }else if(num > 100 && num <=1000){
                number = Math.floor(num/100)*100 + 200
            }else if(num > 1000){
                number = Math.floor(num/1000)*1000 + 2000
            }
            myChart4.setOption({
                
                series: [
                {
                    
                    max: number,
                   
                    data: [{ value: result.Data, name: '' }]
                },
                {
                    
                    detail: {
                        formatter: function() {
                            return "待处理工单最大量    " + result.Data
                        },
                    },

                }
                ]
            });
        }
        function setChart5(data){
            var total = 0;
            var max = 0;
            for (var i = 0; i < data.length; i++) {
                total += Number(data[i].AvgScore)
                if(Number(data[i].AvgScore) > max) {
                    max = Number(data[i].AvgScore)
                }
            }
            var percent = data.length ? (total / data.length).toFixed(2) : "";
            percent = percent ? fomatVerg(percent) : "*";
            $('.myzc_fw .ratio').text(percent +'星')
            $('.myzc_fw').show();
            formdata5(data,percent,max) 
        }
        function setChart6(data){
            $('.legend').show();
            formdata6(data)
        }

        function setChart7(data){
            var data7 = [];
            var _data = [];
            var max = 0;
            for (var i = 0; i < data.length; i++) {
                var o = {};
                var obj = {};
                if(data[i].DistrictID == '0816.004'){
                    o.name = '涪城区'
                    obj.name = '涪城区'
                }else if(data[i].DistrictID == '0816.010'){
                    o.name = '游仙区'
                    obj.name = '游仙区'
                }
                else if(data[i].DistrictID == '0816.001'){
                    o.name = '安州区'
                    obj.name = '安州区'
                }
                else if(data[i].DistrictID == '0816.008'){
                    o.name = '三台县'
                    obj.name = '三台县'
                }else if(data[i].DistrictID == '0816.009'){
                    o.name = '盐亭县'
                    obj.name = '盐亭县'
                }else if(data[i].DistrictID == '0816.011'){
                    o.name = '梓潼县'
                    obj.name = '梓潼县'
                }else if(data[i].DistrictID == '0816.002'){
                    o.name = '北川羌族自治县'
                    obj.name = '北川羌族自治县'
                }else if(data[i].DistrictID == '0816.007'){
                    o.name = '平武县'
                    obj.name = '平武县'
                }else if(data[i].DistrictID == '0816.006'){
                    o.name = '江油市'
                    obj.name = '江油市'
                }else if(data[i].DistrictID == '0816.005'){
                    o.name = '高新区'
                    obj.name = '高新区'
                }
                o.value = data[i].Count 
                obj.value = data[i].Count +'（' + data[i].Percent + '%）'
                data7.push(o)
                _data.push(obj)

            }
            
            for(var k=0;k<data7.length;k++){
                if(data7[k].value > max){
                    max = data7[k].value 
                }
            }

            var option = {
                
                tooltip: {

                    formatter: function(params) {
                        if (typeof(params.value)[2] == "undefined") {
                            for (var i = 0; i < _data.length; i++) {
                                if(_data[i].name == params.name){
                                    console.log(_data[i])
                                    return params.name + ' : ' + _data[i].value;
                                }
                            }
                        } else {
                            return params.name + ' : ' + params.value[2];
                        }
                    }
                },
                visualMap: {
                    max: max,

                },
                series: [
                    {
                        data: data7
                    },
                    {
                        data: data7.sort(function (a, b) { return b.value - a.value; })
                    },
                    {
                        data: convertData(data7),
                    },
                    {
                        data: convertData(data7),
                    },
                    {
                        data: convertData(data7), 
                    },
                    
                ]
            };
            myChart7.setOption(option)
        }
        function getChart4() {
            var opts = {
                url: request.baseUrl + request.maxGd + "?token=" + token,
                type: "get",
                /*headers: {
                    token: token
                },*/
                dataType: "json",
                successCb: function(result) {
                    if (result.Success) {
                        _data4 = result;
                        setChart4(result)
                    } else {
                        setChart4(_data4)
                    }
                },
                errorCb: function(err) {
                    setChart4(_data4)
                },
                completeCb: function() {
                    if(flag4){
                        myChart4.hideLoading();
                        flag4 = false;
                        timer4 = setInterval(function(){
                            getChart4()
                        },time4*1000);
                    }
                    console.log("complete");
                }
            }
            req.requst(opts)
        }

        function getChart2() {
            var opts = {
                url: request.baseUrl + request.kfHourUrl + "?token=" + token,
                type: "get",
              /*  headers: {
                    token: token
                },*/
                dataType: "json",
                successCb: function(result) {
                    if (result.Success) {
                        _data2 = [].concat(result.Data);
                        data2 = result.Data;
                        setChart2(data2)
                    } else {
                        var data = [].concat(_data2);
                        setChart2(data)
                    }
                },
                errorCb: function(err) {
                    var data = [].concat(_data2);
                    setChart2(data)
                },
                completeCb: function() {
                    if(flag2){
                        myChart2.hideLoading();
                        flag2 = false;
                        timer2 = setInterval(function(){
                            getChart2()
                        },time2*1000);
                    }
                    console.log("complete");
                }
            }
            req.requst(opts)
        }

        function getChart1() {
            var opts = {
                url: request.baseUrl + request.pWorkOrder + "?token=" + token,
                type: "get",
               /* headers: {
                    token: token
                },*/
                dataType: "json",
                successCb: function(result) {
                    if (result.Success) {
                        _data1 = [].concat(result.Data);
                        setChart1(result.Data)
                    } else {
                        var data = [].concat(_data1);
                        setChart1(data)
                    }
                },
                errorCb: function(err) {
                    var data = [].concat(_data1);
                    setChart1(data)
                },
                completeCb: function() {
                    if(flag1){
                        myChart1.hideLoading();
                        flag1 = false;
                        timer1 = setInterval(function(){
                            getChart1()
                        },time1*1000);
                    }

                    console.log("complete");
                }
            }
            req.requst(opts)
        }
        function getChart7() {
            var opts = {
                url: request.baseUrl + request.qxWorkOrder + "?token=" + token,
                type: "get",
                /*headers: {
                    token: token
                },*/
                dataType: "json",
                successCb: function(result) {
                    if (result.Success) {
                        _data7 = [].concat(result.Data);
                        setChart7(result.Data)
                        
                    } else {
                        var data = [].concat(_data7);
                        setChart7(data)
                    }
                },
                errorCb: function(err) {
                    var data = [].concat(_data7);
                    setChart7(data)
                },
                completeCb: function() {
                    if(flag7){
                        myChart7.hideLoading()
                        flag7 = false;
                        timer7 = setInterval(function(){
                            getChart7()
                        },time7*1000);
                    }
                    console.log("complete");
                }
            }
            req.requst(opts)
        }
        function getChart3() {
            var opts = {
                url: request.baseUrl + request.kfzcUrl + "?token=" + token,
                type: "get",
                /*headers: {
                    token: token
                },*/
                dataType: "json",
                successCb: function(result) {
                    if (result.Success) {
                        _data3 = [].concat(result.Data);
                        setChart3(result.Data);
                    } else {
                        var data = [].concat(_data3);
                        setChart3(data);
                    }
                },
                errorCb: function(err) {
                    var data = [].concat(_data3);
                    setChart3(data);
                },
                completeCb: function() {
                    if(flag3){
                        myChart3.hideLoading(); //隐藏加载动画
                        flag3 = false;
                        timer3 = setInterval(function(){
                            getChart3()
                        },time3*1000);
                    }
                    console.log("complete");
                }
            }
            req.requst(opts)
        }
        function getChart6() {
            var opts = {
                url: request.baseUrl + request.onlineStatus,
                type: "get",
                data:{
                    token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.ZXlKcGNDSTZJalV4TWk0MU1USXVOVEV5TGpVeE1pSXNJbVY0Y0NJNk1UVTJORFUxTmpJeU9EVTFNWDA9DQo.yw-PovMQ-I_LyRFso1fvB6W5kQpIN_8bz9nRsw4EtzY'
                },
                successCb: function(result) {
                    result = JSON.parse(result)
                    if (result.code == 200) {
                        _data6 = [].concat(result.Data)
                        data6 = result.Data
                        setChart6(data6)
                    } else {
                        var data = [].concat(_data6);
                        setChart6(data)
                    }
                },
                errorCb: function(err) {
                    var data = [].concat(_data6);
                    setChart6(data)
                },
                completeCb: function() {
                    if(flag6){
                        myChart6.hideLoading();
                        flag6 = false;
                        timer6 = setInterval(function(){
                            getChart6()
                        },time6*1000);
                    }
                    console.log("complete");
                }
            }
            req.requst(opts)
        }
        function formdata2(dt,verge,max){
            var nameArr=[]
            var valueArr=[]
            if(dt.length > 5 && _data2.length >5){
                clearTimeout(timer21);
                timer21 = setTimeout(function(){
                    formdata2(data2,verge,max)
                },2000)
                var data = dt.splice(0,5);
                for (var i = 0; i < data.length; i++) {
                    if(typeof data[i] == 'object'){
                        nameArr.push(data[i].RealName)
                        valueArr.push(data[i].Average)
                    }
                }

                myChart2.setOption({ //加载数据图表
                    xAxis: {
                        data: nameArr,
                    },
                    yAxis:{
                        max:max
                    },
                    series: [{
                        markLine: {                      //开始标预警线
                            data: [
                                {
                                    name: '',
                                    yAxis: verge
                                },
                            ],
                        },
                        data: valueArr,

                    }]
                });
            }else if(dt.length <= 5 && _data2.length >5 ){
                var newData = dt.concat(_data2);
                clearTimeout(timer21);
                timer21 = setTimeout(function(){
                    formdata2(newData,verge,max)
                },2000)
                var data = newData.splice(0,5);
                for (var i = 0; i < data.length; i++) {
                    if(typeof data[i] == 'object'){
                        nameArr.push(data[i].RealName)
                        valueArr.push(data[i].Average)
                    }
                }
                myChart2.setOption({
                    xAxis: {
                        data: nameArr,
                    },
                    yAxis:{
                        max:max
                    },
                    series: [{
                        markLine: { 
                            data: [
                                {
                                    name: '',
                                    yAxis: verge
                                },
                            ],
                        },
                        data: valueArr,

                    }]
                });
            }else{
               for (var i = 0; i < dt.length; i++) {
                   if(typeof dt[i] == 'object'){
                       nameArr.push(dt[i].RealName)
                       valueArr.push(dt[i].Average)
                   }
               }
               myChart2.setOption({
                   xAxis: {
                       data: nameArr,
                   },
                   yAxis:{
                       max:max
                   },
                   series: [{
                       markLine: {
                           data: [
                               {
                                   name: '',
                                   yAxis: verge
                               },
                           ],
                       },
                       data: valueArr,

                   }]
               }); 
            }

        }
        function formdata5(dt,verge,max){
            var nameArr=[]
            var valueArr=[]
            if(dt.length > 5 && _data5.length >5){
                clearTimeout(timer51);
                timer51 = setTimeout(function(){
                    formdata5(data5,verge,max)
                },2000)
                var data = dt.splice(0,5);
                for (var i = 0; i < data.length; i++) {
                    if(typeof data[i] == 'object'){
                        nameArr.push(data[i].AgentName)
                        valueArr.push(data[i].AvgScore)
                    }
                }
                myChart5.setOption({
                    xAxis: {
                        data: nameArr,
                    },
                    yAxis:{
                        max:max
                    },
                    series: [{
                        markLine: { 
                           data: [
                                {
                                    name: '',
                                    yAxis: verge
                                },
                            ],
                        },
                        data: valueArr
                    }]
                });
            }else if(dt.length <=5 && _data5.length >5 ){
                var newData = dt.concat(_data5);
                clearTimeout(timer51);
                timer51 = setTimeout(function(){
                    formdata5(newData,verge,max)
                },2000)
                var data = newData.splice(0,5);
                for (var i = 0; i < data.length; i++) {
                    if(typeof data[i] == 'object'){
                        nameArr.push(data[i].AgentName)
                        valueArr.push(data[i].AvgScore)
                    }
                }
                myChart5.setOption({ 
                    xAxis: {
                        data: nameArr,
                    },
                    yAxis:{
                        max:max
                    },
                    series: [{
                        markLine: { 
                           data: [
                                {
                                    name: '',
                                    yAxis: verge
                                },
                            ],
                        },
                        data: valueArr
                    }]
                });
            }else{
                for (var i = 0; i < dt.length; i++) {
                    if(typeof dt[i] == 'object'){
                        nameArr.push(dt[i].AgentName)
                        valueArr.push(dt[i].AvgScore)
                    }
                }
                myChart5.setOption({
                    xAxis: {
                        data: nameArr,
                    },
                    yAxis:{
                        max:max
                    },
                    series: [{
                        markLine: { 
                           data: [
                                {
                                    name: '',
                                    yAxis: verge
                                },
                            ],
                        },
                        data: valueArr
                    }]
                });
            }

        }
        function formdata6(dt){
            if(dt.length){
                for (var i = 0; i < dt.length; i++) {
                    if(dt[i].Status == '退出'){
                        logout.push(dt[i])
                    }else if(dt[i].Status == '接单'){
                        online.push(dt[i])
                    }else if(dt[i].Status == '不接单'){
                        offline.push(dt[i])
                    }else if(dt[i].Status == '隐身'){
                        hide.push(dt[i])
                    }
                }
                showShap()
            }else{
                clearInterval(timer61)
                getChart6();
            }

        }
        function showShap(){
            var nameArr=[]
            var valueArr=[]
            if(online.length > 0) {
                clearTimeout(timer61);
                timer61 = setTimeout(function(){
                    showShap()
                },2000)
                var data = online.splice(0,5);
                for (var i = 0; i < data.length; i++) {
                    if(typeof data[i] == 'object'){
                        nameArr.push(data[i].realname)
                        valueArr.push(1)
                    }
                }
                myChart6.setOption({
                    xAxis: {
                        data: nameArr,
                    },
                    series: [{
                        itemStyle: {
                             normal: {
                                 color: '#0be591'
                             }
                         },
                        data: valueArr
                    }]
                });
            }else if(offline.length >0){
                clearTimeout(timer61);
                timer61 = setTimeout(function(){
                    showShap()
                },2000)
                var data = offline.splice(0,5);
                for (var i = 0; i < data.length; i++) {
                    if(typeof data[i] == 'object'){
                        nameArr.push(data[i].realname)
                        valueArr.push(1)
                    }
                }
                myChart6.setOption({
                    xAxis: {
                        data: nameArr,
                    },
                    series: [{
                        itemStyle: {
                             normal: {
                                 color: '#cd8800'
                             }
                         },
                        data: valueArr
                    }]
                });
            }else if(hide.length >0){
                clearTimeout(timer61);
                timer61 = setTimeout(function(){
                    showShap()
                },2000)
                var data = hide.splice(0,5);
                for (var i = 0; i < data.length; i++) {
                    if(typeof data[i] == 'object'){
                        nameArr.push(data[i].realname)
                        valueArr.push(1)
                    }
                }
                myChart6.setOption({
                    xAxis: {
                        data: nameArr,
                    },
                    series: [{
                        itemStyle: {
                             normal: {
                                 color: '#26c6ff'
                             }
                         },
                        data: valueArr
                    }]
                });
            }else if(logout.length >0){
                clearTimeout(timer61);
                timer61 = setTimeout(function(){
                    showShap()
                },2000)
                var data = logout.splice(0,5);
                for (var i = 0; i < data.length; i++) {
                    if(typeof data[i] == 'object'){
                        nameArr.push(data[i].AgentName)
                        valueArr.push(1)
                    }
                }

                myChart6.setOption({
                    xAxis: {
                        data: nameArr,
                    },
                    series: [{
                        itemStyle: {
                             normal: {
                                 color: '#f55719'
                             }
                         },
                        data: valueArr
                    }]
                });
            }else{
                clearTimeout(timer61);
                var newData = [].concat(_data6);
                formdata6(newData)
            }
        }
        
        function getChart5() {
            var opts = {
                url: request.baseUrl + request.evaluate,
                type: "get",

                data:{
                    token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.ZXlKcGNDSTZJalV4TWk0MU1USXVOVEV5TGpVeE1pSXNJbVY0Y0NJNk1UVTJORFUxTmpJeU9EVTFNWDA9DQo.yw-PovMQ-I_LyRFso1fvB6W5kQpIN_8bz9nRsw4EtzY'
                },
                successCb: function(result) {
                    result = JSON.parse(result)
                    if (result.code == 200) {
                        _data5 = [].concat(result.Data.Detail)
                        data5 = result.Data.Detail
                        setChart5(data5)
                    } else {
                        var data = [].concat(_data5);
                        setChart5(data)
                    }
                },
                errorCb: function(err) {
                    var data = [].concat(_data5);
                    setChart5(data)
                },
                completeCb: function() {
                    if(flag5){
                        myChart5.hideLoading();
                        flag5 = false;
                        timer5 = setInterval(function(){
                            getChart5()
                        },time5*1000);
                    }
                    console.log("complete");
                }
            }
            req.requst(opts)
        }
        function fomatVerg(n){
            if(n.split('.')[1] != '00'){
                if(n.split('.')[1] % 10 == 0){
                    return n.substring(0,n.length-1)
                }
                return n
            };
            return n.split('.')[0]
        }
        window.onresize = function() {
            myChart1.resize();
            myChart2.resize();
            myChart3.resize();
            myChart4.resize();
            myChart5.resize();
            myChart6.resize();
            myChart7.resize();
        };
        $('.cancelbtn').on('click',function(){
            $('.mask').hide()
        })
        var id = '';
        $('.confirm').on('click',function(){
            var time = $('#selected-type').val()
            if(id == 1){
                time1 = time
                clearInterval(timer1);
                timer1 = setInterval(function(){
                    getChart1()
                },time1*1000)
            }else if(id == 2){
                time2 = time
                clearInterval(timer2);
                timer2 = setInterval(function(){
                    getChart2()
                },time2*1000)
            }else if(id == 3){
                time3 = time
                clearInterval(timer3);
                timer3 = setInterval(function(){
                    getChart3()
                },time3*1000)
            }else if(id == 4){
                time4 = time
                clearInterval(timer4);
                timer4 = setInterval(function(){
                    getChart4()
                },time4*1000)
            }else if(id == 5){
                time5 = time
                clearInterval(timer5);
                timer5 = setInterval(function(){
                    getChart5()
                },time5*1000)
            }else if(id == 6){
                time6 = time
                clearInterval(timer6);
                timer6 = setInterval(function(){
                    getChart6()
                },time6*1000)
            }else if(id == 7){
                time7 = time
                clearInterval(timer7);
                timer7 = setInterval(function(){
                    getChart7()
                },time7*1000)
            }
            $('.mask').hide()
        })
        
        $('#types').on('change',function(){
            $('#selected-type').val($('#types option:selected').text())
        })
        $('.chart_title .btn').on('click',function(){
            id = $(this).attr('data-id')
            if(id == 1){
                $('#selected-type').val(time1)
                $('#types').val(time1)
            }else if(id == 2){
                $('#selected-type').val(time2)
                $('#types').val(time2)
            }else if(id == 3){
                $('#selected-type').val(time3)
                $('#types').val(time3)
            }else if(id == 4){
                $('#selected-type').val(time4)
                $('#types').val(time4)
            }else if(id == 5){
                $('#selected-type').val(time5)
                $('#types').val(time5)
            }else if(id == 6){
                $('#selected-type').val(time6)
                $('#types').val(time6)
            }else if(id == 7){
                $('#selected-type').val(time7)
                $('#types').val(time7)
            }
            $('.mask').show()
        })
    })
})