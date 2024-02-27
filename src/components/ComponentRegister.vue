<template>
<div class="main-component">
    <div class="popup-component">
        <v-card>
            <v-form @submit.prevent="onSubmit" class="p-3">
                <v-card-title>
                    <span class="text-h5">ĐĂNG KÝ TÀI KHOẢN</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="12" class="p-0">
                                <v-text-field v-model="formData.name" label="Họ và tên*" :rules="[rules.required]"></v-text-field>
                            </v-col>
                            <v-col cols="12" class="p-0">
                                <v-text-field v-model="formData.userID" label="Mã số nhân viên*" :rules="[rules.required]"></v-text-field>
                            </v-col>
                            <v-col cols="12" class="p-0">
                                <v-select v-model="formData.jobPosition" :items="jobPositionItems" label="Vị trí công việc" persistent-hint return-object single-line></v-select>
                            </v-col>
                            <v-col cols="12" class="p-0">
                                <v-select v-model="formData.area" :items="areaList" label="Khu vực làm việc" persistent-hint return-object single-line></v-select>
                            </v-col>
                            <v-col cols="12" class="p-0">
                                <v-label>Giờ làm:</v-label>
                                <v-radio-group column v-model="GioLam">
                                    <v-radio label="Hành chính" value="1"></v-radio>
                                    <v-radio label="Đi ca" value="2"></v-radio>
                                </v-radio-group>
                                <v-select v-model="formData.kip" :items="itemKIP" solo label="Chọn Ca" v-if="GioLam == 2"></v-select>
                            </v-col>
                            <v-col cols="12" class="p-0">
                                <v-text-field v-model="formData.email" label="Email*" :rules="[rules.required, rules.email, rules.formatEmail]"></v-text-field>
                            </v-col>
                            <v-col cols="12" class="p-0">
                                <v-text-field v-model="formData.pass" label="Password*" type="password" :rules="[rules.required]"></v-text-field>
                            </v-col>
                        </v-row>
                    </v-container>
                    <small>*là những trường bắt buộc</small>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue-darken-1" variant="text" @click="handleClose">
                        Đóng
                    </v-btn>
                    <v-btn color="blue-darken-1" variant="text" @click="handleSave">
                        Lưu
                    </v-btn>
                </v-card-actions>
            </v-form>
        </v-card>
    </div>
</div>
</template>

<script>
import {
    JOB_POSITION_ITEMS,
    AREA_LIST
} from '../js/dataUser'
export default {
    props: {

    },
    data() {
        return {
            formData: {
                name: "",
                pass: "",
                userID: "",
                email: "",
                jobPosition: "",
                status: 0,
                role: 1,
                kip: "",
                area: "",
            },
            rules: {
                required: (value) => !!value || "Bắt buộc.",
                email: (value) => {
                    const pattern =
                        /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                    return pattern.test(value) || "Email không hợp lệ.";
                },
                formatEmail: (value) =>
                    !!value.includes("hoaphat.com.vn") || "Email không thuộc công ty",
            },
            jobPositionItems: JOB_POSITION_ITEMS,
            areaList: AREA_LIST
        }
    },
    methods: {
        handleClose() {
            console.log("[ComponentRegister] handle close");
            this.$emit('signalHandleClose');
        },
        handleSave() {
            console.log("[ComponentRegister] handle save");
            this.$emit('signalHandleSave');
        }
    }
}
</script>

<style scoped>
.main-component {
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
    margin-left: 0px;
}

.popup-component {
    width: 1024px;
}
.custom-text-field input:focus {
  color: red;
}
</style>
