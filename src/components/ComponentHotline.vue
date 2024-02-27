<template>
<div v-if="isActiveFormHotline" class="main">
    <div class="content">
        <header>
            <div class="header">
                <div class="title">{{ $t('Hotline') }}</div>
                <div class="icon"><i class="fas fa-times close-icon" @click="HandleCancel"></i></div>
            </div>
        </header>
        <div class="tab-table">
            <table class="custom-table" style=" margin-top: 7px;font-size:14px;">
                <thead>
                    <tr>
                        <th class="fix-header th-id">{{$t('No')}}</th>
                        <th class="fix-header th-fullname">{{ $t('FullName') }}</th>
                        <th class="fix-header th-userid">{{ $t('EmployeeNumber') }}</th>
                        <th class="fix-header th-position">{{ $t('JobPosition') }}</th>
                        <th class="fix-header th-hour">{{ $t('WorkPlace') }}</th>
                        <th class="fix-header th-email">Email</th>
                        <th class="fix-header th-delete">{{$t('Phone')}}</th>
                        <th class="fix-header th-setting">Teams</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(userItem) in userHotlineList" :key="userItem.id">
                        <td class="td-id">{{ userItem.id }}</td>
                        <td class="td-fullname">{{ userItem.fullname }}</td>
                        <td class="td-userid">{{ userItem.userid }}</td>
                        <td class="td-position">{{ userItem.position }}</td>
                        <td class="td-area">{{ userItem.area }}</td>
                        <td class="td-email">
                            <div style="display: flex; justify-content: center;">
                                <a :href="'mailto:'+ userItem.email">
                                    <i style="display:block" class="icon-mail"></i>
                                </a>
                            </div>
                        </td>
                        <td class="td-hour">
                            {{ userItem.phone }}
                        </td>
                        <td class="td-hour">
                            <div style=" display: flex;justify-content: center;">
                                <a :href="'sip:' + userItem.email" style="text-decoration: none">
                                    <i style=" display: block; " class="icon-microsoft-team"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
</template>

<script>
import axios from 'axios';
export default {
    props: {
        isActiveFormHotline: {
            type: Boolean,
            default: false
        },
    },
    data() {
        return {
            // userHotlineList: [{
            //         id: 1,
            //         fullname: "NGUYEN HOANG TRUNG",
            //         userid: "HPDQ25354",
            //         position: "Information technology technician",
            //         area: "PX. Đúc",
            //         email: "trungnh2@hoaphat.com.vn",
            //         phone: "0363171307",
            //         team: "sip:",
            //     },
            //     {
            //         id: 2,
            //         fullname: "NGO VAN SAP",
            //         userid: "HPDQ25354",
            //         position: "Information technology technician",
            //         area: "PX. Đúc",
            //         email: "ngovansap@hoaphat.com.vn",
            //         phone: "0961515964",
            //         team: "sip:",
            //     }
            // ],
            userHotlineList: [],
        }
    },
    methods: {
        HandleCancel() {
            this.$emit("signalCloseFormHotline");
        },
        convertJobPosition(jobID) {
            let convertPosition = "";
            switch (jobID) {
                case 1:
                    convertPosition = this.$t('DirectorDeputyDirector');
                    break;
                case 2:
                    convertPosition = this.$t('ForemanDeputyForeman');
                    break;
                case 3:
                    convertPosition = this.$t('InCharge');
                    break;
                case 4:
                    convertPosition = this.$t('Technician');
                    break;
                case 5:
                    convertPosition = this.$t('Operate');
                    break;
                case 6:
                    convertPosition = this.$t('Employee');
                    break;
                default:
                    convertPosition = "";
            }
            return convertPosition;
        },

        convertArea(areaID) {
            let convertArea = "";
            switch (areaID) {
                case 1:
                    convertArea = this.$t('PXTSC');
                    break;
                case 2:
                    convertArea = this.$t('PXHSM');
                    break;
                case 3:
                    convertArea = this.$t('FurnaceArea');
                    break;
                case 4:
                    convertArea = this.$t('WaterTreatment');
                    break;
                case 5:
                    convertArea = "VP NM.CT QSP";
                    break;
                case 6:
                    convertArea = "NM.CT HRC2";
                    break;
                default:
                    convertArea = "";
            }
            return convertArea;
        },
        async HandleHotline() {
            this.userHotlineList = [];
            const jsonDataHotlineInfo = {
                userID: this.$globalVariable.USER_INFO.userID,
            };
            console.log("(HandleHotline) Json Data Hotline Info: ", jsonDataHotlineInfo);
            const jsonStringHotlineInfo = JSON.stringify(jsonDataHotlineInfo);
            console.log("(HandleHotline) Json String Hotline Info: ", jsonStringHotlineInfo);
            await axios.post(this.$globalVariable.URL_API + '/ManageAccess/hotline_info', jsonStringHotlineInfo, {
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(response => {
                console.log("(HandleHotline) Data Response: ", response.data);
                console.log("(HandleHotline) userID: ", response.data.userID);
                console.log("(HandleHotline) length: ", response.data.data.length);
                for (let i = 0; i < response.data.data.length; i++) {
                    const dataItem = response.data.data[i];

                    var userHotlineItem = {
                        id: i + 1,
                        fullname: dataItem["fullName"],
                        userid: dataItem["userID"],
                        position: this.convertJobPosition(dataItem["jobID"]),
                        area: this.convertArea(dataItem["areaID"]),
                        email: dataItem["email"],
                        phone: dataItem["phone"],
                        team: dataItem["team"],
                    };
                    console.log("(HandleHotline) User Hotline Item: ", userHotlineItem);
                    this.userHotlineList.push(userHotlineItem);
                }
                console.log("(HandleHotline) Array User Hotline Push: ", this.userHotlineList);

            }).catch(error => {
                console.error("(HandleHotline) error: ", error);
            })

        },
        HandleOpenMicroSoftTeam() {
            const sipLink = "sip:thienld@hoaphat.com.vn";
            window.open(sipLink, '_blank');
        },
    },
    computed: {

    },
    watch: {
        isActiveFormHotline(newValue, oldValue) {
            console.log("(isActiveFormHotline) new Value: ", newValue);
            console.log("(isActiveFormHotline) old Value: ", oldValue);
            if (newValue == true && oldValue == false) {
                this.HandleHotline();
            }
        }
    }
}
</script>

<style scoped>
.main {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.content {
    position: relative;
    font-family: Arial, Helvetica, sans-serif;
    background-color: #fff;
    padding: 0px;
    border: 4px;
    width: 59%;
}

.header {
    display: flex;
    height: 50px;
    width: 100%;
    justify-content: space-between;
    align-items: center;
    vertical-align: middle;
    background-color: #000;
    padding-right: 5px;
    color: #fff;
}

.title {
    border-radius: 5px;
    font-weight: bold;
    padding-left: 10px;
    border: none;
    width: 48%;
}

.icon {
    text-align: right;
    cursor: pointer;
    margin-right: 10px;
    color: #fff;
    width: 48%;
}

.icon i {
    font-size: 20px;
    color: #fff;
}

.icon i:hover {
    font-size: 20px;
    color: #757575;
}

.menu-search {
    width: 100%;
    display: flexbox;
    border: none;
    margin-top: 0px;
    background-color: #fff;
    /* background: linear-gradient(to bottom, #B3E5FC, #fff); */
    height: 70px;
    padding-left: 20px;
    padding-top: 15px;
    overflow: hidden;
    align-items: right;
}

.content-search {
    border: 1px solid none;
    display: flex;
    float: right;
    padding-right: 20px;
}

.input {
    border: 1px solid #ccc;
    width: 400px;
    height: 40px;
    border-radius: 3px;
    padding: 10px;
    font-size: 16px;
    color: #333;
    margin-top: 1px;
    margin-bottom: 25px;
    margin-left: 14px;
    margin-right: 10px;
}

.input:focus {
    outline: none;
    border-color: #4caf50;
    box-shadow: 0 0 4px #4caf50;
}

.input.disabled {
    pointer-events: none;
    /* vô hiệu hóa tương tác với thẻ input khi bị disable */
    opacity: 0.9;
    /* giảm độ sáng cho thẻ input khi bị disable */
    background-color: bisque;
}

.open-popup {
    display: flex;
    border: 1px solid transparent;
    border-radius: 4px;
    height: 40px;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 16px;
    cursor: pointer;
    background-color: transparent;
    margin-bottom: 1px;
    text-align: center;
    align-items: center;
    justify-content: center;
    padding: 10px;
    margin-right: 10px;
    text-decoration: none;
}

.open-popup:hover {
    border: 1px solid #64B5F6;
    background-color: #E3F2FD;
    transition: all 0.3s ease;
}

.icon-open-popup {
    display: inline-block;
    width: 24px;
    height: 24px;
    background-image: url(../assets/search.png);
    background-size: cover;
    background-position: center;
    margin-right: 10px;
    border: none;
}

.icon_loading {
    width: 24px;
    height: 24px;
    border: 1px solid none;
    background: transparent;
    color: #333;
    background-image: url('../assets/loading.gif');
    background-size: 24px;
    font-size: 24px;
    background-repeat: no-repeat;
    background-color: rgba(0, 0, 0, 0);
    margin-right: 10px;
}

.tab-table {
    display: flex;
    justify-content: center;
    align-items: center;
    border: none;
    background-color: #fff;
    width: 100%;
    justify-content: center;
}

.custom-table {
    top: 0;
    width: 99%;
    border-collapse: collapse;
    table-layout: fixed;
    padding: 10px;
    border: 1px solid red;
    float: inline-start;
    margin-bottom: 6px;
}

.fix-header {
    position: sticky;
    top: 0;
    background-color: #fff;
    /* background: linear-gradient(to bottom, #B3E5FC, #fff); */
}

.custom-table th {
    padding: 8px;
    border: 1px solid #B5B5B5;
    height: 30px;
    text-align: center;
}

.custom-table tr,
.custom-table td {
    padding: 8px;
    border: 1px solid #B5B5B5;
}

.th-id {
    width: 1%;
}

.th-fullname {
    width: 5%;
}

.th-userid {
    width: 3.5%;
}

.th-position {
    width: 3%;
}

.th-area {
    width: 12%;
}

.th-hour {
    width: 3%;
}

.th-email {
    width: 2%;
}

.th-delete {
    width: 4%;
}

.th-setting {
    width: 3%;
}

.th-active {
    width: 8%;
}

.td-id {
    text-align: center;
}

.td-delete {
    text-align: center;
}

.td-setting {
    text-align: center;
}

.td-active {
    text-align: center;
}

.table_info {
    display: flexbox;
    bottom: 0;
    position: absolute;
    border: 2px solid #f2f2f2;
    height: 50px;
    width: 100%;
    padding: 12px;
    background: linear-gradient(to bottom, #CFD8DC, #FFF);
    align-items: right;
}

.table_info_data {
    float: right;
    font-family: Arial, Helvetica, sans-serif;
    border: none;
    text-align: right;
    padding-right: 20px;
}

.icon-action {
    cursor: pointer;
    margin-right: 10px;
    padding-left: 10px;
}

.icon-action i {
    font-size: 20px;
    color: red;
}

.icon-action i:hover {
    font-size: 20px;
    color: red;
}

.icon-setting {
    cursor: pointer;
    margin-right: 10px;
    padding-left: 10px;
}

.icon-setting i {
    font-size: 20px;
    color: #1976D2;
}

.icon-setting i:hover {
    font-size: 20px;
    color: #1976D2;
}

.icon-microsoft-team {
    display: inline-block;
    margin-left: 5px;
    width: 24px;
    height: 24px;
    background-image: url(../assets/images/microsoft_teams.png);
    background-size: cover;
    background-position: center;
    border: none;
}

.icon-mail {
    display: inline-block;
    margin-left: 5px;
    width: 24px;
    height: 24px;
    background-image: url(../assets/images/mail.png);
    background-size: cover;
    background-position: center;
    border: none;
}
</style>
