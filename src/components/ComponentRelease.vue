<template>
<div v-if="isActiveFormRelease" class="main">
    <div class="content">
        <header>
            <div class="header">
                <div class="title">{{$t('ReleaseNotes')}}</div>
                <div class="icon"><i class="fas fa-times close-icon" @click="HandleCancel"></i></div>
            </div>
        </header>
        <div class="version-content">
            <div class="version-name">
                <span>Manager draw 1.0</span>
            </div>
            <div class="version-date">
                <span>March 20, 2023</span>
            </div>
            <div v-if="versionList.new_features && versionList.new_features.length > 0" class="version-new__feature">
                <div class="new-feature_title version-font-weight version-margin-six">
                    <span>
                        {{$t('NewFeatures')}}
                    </span>
                </div>
                <div class="new-feature_content version-margin-no">
                    <ul class="new-feature_content-list">
                        <li v-for="versionFeature in versionList.new_features" :key="versionFeature.en" class="new-feature_content-list__item version-margin__item-all">{{ $i18n.locale === 'en' ? versionFeature.en : versionFeature.vn }}</li>
                    </ul>
                </div>
            </div>
            <div v-if="versionList.improvements && versionList.improvements.length > 0" class="version-improvements">
                <div class="version-improvements-title version-font-weight version-margin-six">
                    <span>
                        {{$t('Improvements')}}
                    </span>
                </div>
                <div class="version-improvements-content version-margin-no">
                    <ul class="version-improvements-content-list">
                        <li v-for="versionImprovements in versionList.improvements" :key="versionImprovements.en" class="version-improvements-content-list__item version-margin__item-all">{{ $i18n.locale === 'en' ? versionImprovements.en : versionImprovements.vn }}</li>
                    </ul>
                </div>
            </div>
            <div v-if="versionList.bug_fixes && versionList.bug_fixes.length > 0" class="version-fix__bug">
                <div class="version-fix__bug-title version-font-weight version-margin-six">
                    <span>{{$t('BugFixes')}}</span>
                </div>
                <div class="version-fix__bug-content version-margin-no">
                    <ul class="version-fix__bug-content-list">
                        <li  v-for="versionBug in versionList.bug_fixes" :key="versionBug.en" class="version-fix__bug-content-list__item version-margin__item-all">{{ $i18n.locale === 'en' ? versionBug.en : versionBug.vn }}</li>
                    </ul>
                </div>
            </div>
            <div v-if="versionList.limitation && versionList.limitation.length > 0" class="version-limitation">
                <div class="version-limitation-title version-font-weight version-margin-six">
                    <span>{{$t('Limitation')}}</span>
                </div>
                <div class="version-limitation-content version-margin-no">
                    <ul class="version-limitation-content-list">
                        <li v-for="versionLimitation in versionList.limitation" :key="versionLimitation.en" class="version-limitation-content-list__item version-margin__item-all">{{ $i18n.locale === 'en' ? versionLimitation.en : versionLimitation.vn }}</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
</template>
<script>
import axios from 'axios';
export default {
    props: {
        isActiveFormRelease: {
            type: Boolean,
            default: false
        },
    },
    data() {
        return {
            versionList: [],
        }
    },
    watch: {
        isActiveFormRelease(newValue, oldValue) {
            console.log("(isActiveFormRelease) new Value: ", newValue);
            console.log("(isActiveFormRelease) old Value: ", oldValue);
            if (newValue == true && oldValue == false) {
                this.HandleRelease();
            }
        }
    },
    methods: {
        HandleCancel() {
            this.$emit("signalCloseFormRelease");
        },

        async HandleRelease() {
            this.versionList = [];
            const jsonDataReleaseInfo = {
                userID: this.$globalVariable.USER_INFO.userID,
            };
            console.log("(HandleRelease) Json Data Release Info: ", jsonDataReleaseInfo);
            const jsonStringReleaseInfo = JSON.stringify(jsonDataReleaseInfo);
            console.log("(HandleRelease) Json String Release Info: ", jsonStringReleaseInfo);

            await axios.post(this.$globalVariable.URL_API + '/ManageAccess/release_info', jsonStringReleaseInfo, {
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(response => {
                const dataFromDatabase = response.data.data[0].data;
                const parsedData = JSON.parse(dataFromDatabase);
                this.versionList = parsedData;
                console.log("(HandleRelease) Version List: ", this.versionList);
                console.log("(HandleRelease) Data Response: ", parsedData);

            }).catch(error => {
                console.error("(HandleRelease) error: ", error);
            })
        },

    },
    computed: {

    },

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
    width: 30%;
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
    position: absolute;
    justify-content: center;
    align-items: center;
    border: none;
    background-color: #fff;
    width: 100%;
    justify-content: center;
}

.custom-table {
    position: absolute;
    top: 0;
    width: 99%;
    border-collapse: collapse;
    table-layout: fixed;
    padding: 10px;
    border: 1px solid red;
    float: inline-start;
}

.fix-header {
    position: sticky;
    top: 0;
    background-color: #fff;
    /* background: linear-gradient(to bottom, #B3E5FC, #fff); */
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

.version-content div {
    margin-bottom: 20px;
}

.version-content {
    padding: 20px;
}

.version-name {
    font-size: 31px;
    font-weight: 700;
}

.new-feature_content ul {
    margin: 0;
}

.version-font-weight {
    font-weight: 700;
}

.version-margin-no {
    margin: 0 !important;
}

.version-margin-six {
    margin-bottom: 6px !important;
}

.version-margin__item-all {
    margin-bottom: 4px;
}
</style>
