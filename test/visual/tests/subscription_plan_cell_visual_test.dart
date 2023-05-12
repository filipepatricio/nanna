import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_cell.dart';
import 'package:flutter/material.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(
    SubscriptionPlanCell,
    (tester) async {
      final plans = SubscriptionPlanGroup(plans: TestData.subscriptionPlansWithoutTrial);
      final trialPlans = SubscriptionPlanGroup(plans: TestData.subscriptionPlansWithTrial);

      final highestCostTrialSelected = SubscriptionPlanCell(
        plan: trialPlans.highestMonthlyCostPlan,
        highestMonthlyCostPlan: trialPlans.highestMonthlyCostPlan,
        isSelected: true,
        onPlanPressed: (_) {},
      );
      final highestCostTrialUnselected = SubscriptionPlanCell(
        plan: trialPlans.highestMonthlyCostPlan,
        highestMonthlyCostPlan: trialPlans.highestMonthlyCostPlan,
        isSelected: false,
        onPlanPressed: (_) {},
      );
      final lowestCostTrialSelected = SubscriptionPlanCell(
        plan: trialPlans.plans.firstWhere((plan) => plan.productId != trialPlans.highestMonthlyCostPlan.productId),
        highestMonthlyCostPlan: trialPlans.highestMonthlyCostPlan,
        isSelected: true,
        onPlanPressed: (_) {},
      );
      final lowestCostTrialUnselected = SubscriptionPlanCell(
        plan: trialPlans.plans.firstWhere((plan) => plan.productId != trialPlans.highestMonthlyCostPlan.productId),
        highestMonthlyCostPlan: trialPlans.highestMonthlyCostPlan,
        isSelected: false,
        onPlanPressed: (_) {},
      );

      final highestCostSelected = SubscriptionPlanCell(
        plan: plans.highestMonthlyCostPlan,
        highestMonthlyCostPlan: plans.highestMonthlyCostPlan,
        isSelected: true,
        onPlanPressed: (_) {},
      );
      final highestCostUnselected = SubscriptionPlanCell(
        plan: plans.highestMonthlyCostPlan,
        highestMonthlyCostPlan: plans.highestMonthlyCostPlan,
        isSelected: false,
        onPlanPressed: (_) {},
      );
      final lowestCostSelected = SubscriptionPlanCell(
        plan: plans.plans.firstWhere((plan) => plan.productId != trialPlans.highestMonthlyCostPlan.productId),
        highestMonthlyCostPlan: plans.highestMonthlyCostPlan,
        isSelected: true,
        onPlanPressed: (_) {},
      );
      final lowestCostUnselected = SubscriptionPlanCell(
        plan: plans.plans.firstWhere((plan) => plan.productId != trialPlans.highestMonthlyCostPlan.productId),
        highestMonthlyCostPlan: plans.highestMonthlyCostPlan,
        isSelected: false,
        onPlanPressed: (_) {},
      );

      await tester.startApp(
        initialRoute: placeholderRouteWrapper(
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: AppDimens.m,
              mainAxisSpacing: AppDimens.m,
              childAspectRatio: 1.4,
              children: [
                lowestCostTrialSelected,
                lowestCostTrialUnselected,
                highestCostTrialSelected,
                highestCostTrialUnselected,
                lowestCostSelected,
                lowestCostUnselected,
                highestCostSelected,
                highestCostUnselected,
              ],
            ),
          ],
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.autoHeight(),
  );
}
