enum Environment {
  Production,
  Test,
  Qa,
  Local,
}
Map mainUrl = {
  Environment.Test: 'https://test.wxb.com.cn/reborn/',
  Environment.Production: 'https://wxb.sczhbx.com/',
  Environment.Qa: 'http://qa.wxb.com.cn:8000/${EnvConfig.branchName}/reborn/',
  Environment.Local: 'http://172.16.1.180:9090/',
};

class EnvConfig {
  static String branchName = "v3"; // qa环境分支，仅Qa枚举Qa有效
  static Environment env = Environment.Qa; // 当前环境
  static String get originUrl {
    return mainUrl[env];
  }
}
